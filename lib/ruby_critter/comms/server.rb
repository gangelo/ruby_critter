# frozen_string_literal: true

require_relative '../io/configuration'
require_relative '../os/console'
require_relative 'communication'
require_relative 'socket'

module RubyCritter
  module Comms
    # Defines this gem's server.
    class Server
      include Communication
      include OS::Console

      delegate :host, :port, :default_read_block_size,
        :server_read_timeout, to: :configuration

      def initialize(configuration: nil, socket: nil, options: {})
        @configuration = configuration || IO::Configuration.new
        @socket = socket
        @options = options
        setup_signal_traps
      end

      def start
        return if running?

        puts_highlight 'starting up...'

        self.quit = false
        self.listen_thread = Thread.new { listen }
      end

      def stop
        puts_highlight 'shutting down...'
        stop_and_wait_for_listen_thread!
        socket_close!
        puts_success 'shut down.'
      end

      def running?
        return false if listen_thread.nil?

        listen_thread.alive?
      end

      private

      attr_reader :configuration
      attr_writer :socket
      attr_accessor :listen_thread, :options, :quit

      def verbose?
        options.fetch(:verbose, false)
      end

      def debug?
        options.fetch(:debug, false)
      end

      def puts_prefix
        "RubyCritter [server '#{host}':#{port}] >"
      end

      def listen # rubocop:disable Metrics/MethodLength
        puts_highlight 'listening...'

        command = nil

        until quit || quit?(command)
          next unless socket.wait_readable(server_read_timeout)

          command, sender = socket.recvfrom_nonblock(default_read_block_size)
          message = "ACK: #{parse(command)[:op]}"
          puts_success "received command: #{command} from #{sender[3]}:#{sender[1]}" if verbose?
          send_to_client(socket: socket, **sender_address_and_port(sender), message: message)
        end
      rescue IOError => e
        puts_error e.message
      rescue Errno::EADDRINUSE
        puts_error "Address already in use - is the Ruby Critter server already running on '#{host}':#{port}?"
      rescue Errno::ECONNRESET
        puts_error 'Connection reset by peer.'
      rescue JSON::ParserError
        puts_error "Unable to parse command (#{command})."
      rescue ::IO::WaitReadable
        puts_error 'Operation would block - no data received.'
      rescue SocketError => e
        puts_error "Socket Error: #{e.message}."
      ensure
        socket_close!
      end

      def send_to_client(socket:, address:, port:, message:)
        puts_debug "sending message: #{message} to #{address}:#{port}." if debug?
        socket.send(message, 0, address, port)
      end

      def sender_address_and_port(sender)
        {
          address: sender[3],
          port: sender[1]
        }
      end

      def quit?(command)
        command = parse command
        return false if command.blank?

        command[:op] == msg_quit[:op]
      end

      def parse(command)
        JSON.parse(command || '{}', symbolize_names: true)
      end

      def socket
        @socket ||= Socket.new(options: options).tap do |socket|
          socket.bind(host, port)
        end
      end

      def stop_and_wait_for_listen_thread!
        puts_info 'waiting for listening thread to terminate...'
        self.quit = true
        listen_thread.join if running?
        self.listen_thread = nil
      end

      def socket_close!
        return unless @socket && !@socket.closed?

        @socket.close
        self.socket = nil
      end

      def setup_signal_traps
        Signal.trap('INT') do
          puts_highlight 'interrupt (INT) signal received.'
          stop
          exit
        end

        Signal.trap('TERM') do
          puts_highlight 'terminate (TERM) signal received.'
          stop
          exit
        end
      end
    end
  end
end
