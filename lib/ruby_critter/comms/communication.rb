# frozen_string_literal: true

module RubyCritter
  module Comms
    # Message module for the RubyCritter client and server
    module Communication
      COMMAND_BLOCK_SIZE = 1024

      class << self
        def included(base)
          base.const_set(:COMMAND_BLOCK_SIZE, COMMAND_BLOCK_SIZE)
        end
      end

      module_function

      def msg_nop
        { op: 'nop', data: {} }
      end

      def msg_ping
        { op: 'ping', data: {} }
      end

      def msg_quit
        { op: 'quit', data: {} }
      end

      def msg_state(sprite_id:)
        { op: 'state', data: { sprite_id: sprite_id } }
      end
    end
  end
end
