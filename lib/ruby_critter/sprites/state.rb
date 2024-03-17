# frozen_string_literal: true

require 'aasm'

module RubyCritter
  module Sprites
    # Defines the state of a sprite.
    module State
      INITIAL_STATE = :unborn

      attr_reader :state

      # NOTE: DO NOT use this method for anything other than initialization!
      # This method is only used to set the initial status of this attribute
      # AND set the initial state of the AASM. In all other cases, use the
      # AASM event methods.
      def state=(value)
        # TODO: guard
        aasm(:state).current_state = @state = value
      end

      class << self
        def included(base)
          base.include AASM
          base.aasm(:state, column: :state, whiny_transitions: false) do
            state INITIAL_STATE, initial: true
            state :alive
            state :dead

            after_all_transitions :update_state!

            event :birth do
              transitions from: :unborn, to: :alive
            end

            event :resurrect do
              transitions from: :dead, to: :alive
            end

            event :die do
              transitions from: :alive, to: :dead
            end
          end
        end
      end

      private

      def update_state!
        @state = aasm(:state).to_state
      end
    end
  end
end
