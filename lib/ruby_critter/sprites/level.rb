# frozen_string_literal: true

require 'aasm'

module RubyCritter
  module Sprites
    # Defines the level of a sprite.
    module Level
      INITIAL_LEVEL = :one
      LEVEL_RANGES = {
        one: 0..299,
        two: 300..899,
        three: 900..2699,
        four: 2700..6499,
        five: 6500..13999,
        six: 14000..22999,
        seven: 23000..33999,
        eight: 34000..47999,
        nine: 48000..63999,
        ten: 64000..Float::INFINITY
      }.freeze
      LEVEL_NUMBERS = LEVEL_RANGES.keys.map.with_index { |level, index| [level, index + 1] }.to_h.freeze

      attr_reader :level

      # NOTE: DO NOT use this method for anything other than initialization!
      # This method is only used to set the initial status of this attribute
      # AND set the initial state of the AASM. In all other cases, use the
      # AASM event methods.
      def level=(value)
        # TODO: guard
        aasm(:level).current_state = @level = value
      end

      class << self
        def included(base) # rubocop:disable Metrics/MethodLength
          base.include AASM
          base.aasm(:level, column: :level, whiny_transitions: false) do
            state INITIAL_LEVEL, initial: true
            state :two
            state :three
            state :four
            state :five
            state :six
            state :seven
            state :eight
            state :nine
            state :ten

            after_all_transitions :update_level!

            event :level_up do
              transitions from: :one, to: :two, guard: :can_level_up?
              transitions from: :two, to: :three, guard: :can_level_up?
              transitions from: :three, to: :four, guard: :can_level_up?
              transitions from: :four, to: :five, guard: :can_level_up?
              transitions from: :five, to: :six, guard: :can_level_up?
              transitions from: :six, to: :seven, guard: :can_level_up?
              transitions from: :seven, to: :eight, guard: :can_level_up?
              transitions from: :eight, to: :nine, guard: :can_level_up?
              transitions from: :nine, to: :ten, guard: :can_level_up?
            end

            LEVEL_RANGES.each_key do |level|
              base.define_method(:"level_#{level}?") { self.level == level }
            end
          end
        end
      end

      private

      def can_level_up?
        alive? && LEVEL_NUMBERS[level_from_experience] > LEVEL_NUMBERS[level]
      end

      def level_from_experience
        LEVEL_RANGES.find { |_, range| range.include?(experience_points) }&.first || INITIAL_LEVEL
      end

      def update_level!
        @level = aasm(:level).to_state
      end
    end
  end
end
