# frozen_string_literal: true

require_relative '../io/configuration'
require_relative '../os/console'
require_relative 'communication'
require_relative 'socket'

module RubyCritter
  module Comms
    # This is the client that communicates with the RubyCritter service.
    class Client
      include Communication
      include OS::Console

      delegate :host, :port, :default_read_block_size,
        :client_read_timeout, to: :configuration

      def initialize(configuration: nil, socket: nil, options: {})
        @configuration = configuration || IO::Configuration.new(options: options)
        @socket = socket
        @options = options
        ObjectSpace.define_finalizer(self, self.class.send(:finalize, @socket))
      end

      def nop
        send_command command: msg_nop
      end

      def ping
        send_command command: msg_ping
      end

      def state(sprite_id:)
        send_command command: msg_state(sprite_id: sprite_id)
      end

      def quit
        send_command command: msg_quit
      end

      def close
        socket_close!
      end

      def running?
        return false if @socket.nil?

        !@socket.closed?
      end

      class << self
        private

        def finalize(socket)
          proc { socket.close if socket && !socket.closed? }
        end
      end

      private

      attr_reader :configuration
      attr_writer :socket
      attr_accessor :options

      def verbose?
        options.fetch(:verbose, false)
      end

      def puts_prefix
        "RubyCritter [client '#{host}':#{port}] >"
      end

      def send_command(command: msg_nop)
        socket.send(command.to_json, 0, host, port)
        if socket.wait_readable(client_read_timeout)
          response, server = socket.recvfrom_nonblock(default_read_block_size)
          puts_success "response received (#{response}) from #{server[3]}:#{server[1]}." if verbose?
        else
          puts_error "no response received from the server. Is the Ruby Critter server running on '#{host}':#{port}?"
        end
      rescue Errno::ECONNREFUSED
        puts_error_and_close_socket "Connection refused - is the Ruby Critter server running on '#{host}':#{port}?"
      rescue Errno::EHOSTUNREACH
        puts_error_and_close_socket 'Host unreachable - check your network connection.'
      rescue Errno::ETIMEDOUT
        puts_error_and_close_socket 'Connection timed out - the server did not respond.'
      rescue ::IO::WaitReadable
        puts_error_and_close_socket 'Operation would block - no data received.'
      rescue IOError => e
        puts_error_and_close_socket "IO Error - the command ('#{command[:op]}') could not be sent: #{e.message}"
      rescue SocketError => e
        puts_error_and_close_socket "Socket Error: #{e.message}"
      end

      def puts_error_and_close_socket(message)
        puts_error message
        socket_close!
      end

      def socket
        @socket ||= Socket.new(options: options)
      end

      def socket_close!
        return unless @socket && !@socket.closed?

        @socket.close
        self.socket = nil
      end
    end
  end
end
