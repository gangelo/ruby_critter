# frozen_string_literal: true

require 'socket'

module RubyCritter
  module Comms
    # Defines a socket to be used for socket communications.
    class Socket
      delegate :bind, :close, :closed?, :send,
        :recvfrom_nonblock, :wait_readable, to: :socket

      def initialize(options: {})
        @options = options
        @socket = UDPSocket.new
      end

      private

      attr_accessor :socket, :host, :port, :options
    end
  end
end
