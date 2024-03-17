# frozen_string_literal: true

require 'securerandom'
require_relative '../io/sprite_filer'
require_relative '../misc/equatable'
require_relative '../misc/hashable'
require_relative 'level'
require_relative 'sprite_name_transform'
require_relative 'state'

module RubyCritter
  module Sprites
    # Defines a basic sprite, which is the base class for all sprites and critters.
    class SpriteBase
      include IO::SpriteFiler
      include Misc::Equatable
      include Misc::Hashable
      include SpriteNameTransform
      include Level
      include State

      INITIAL_STATE = :unborn
      DEFAULT_ATTRIBUTES = {
        state: INITIAL_STATE,
        sprite_name: 'Sprite',
        # Magical, Melee, Ranged,
        klass: '',
        level: INITIAL_LEVEL,
        # Like d&d race, or combine this will klass or vise versa.
        species: '',
        experience_points: 0,
        # Base attributes
        strength: 0,
        dexterity: 0,
        constitution: 0,
        intelligence: 0,
        wisdon: 0,
        charisma: 0,
        # Skills
        deception: 0,
        insight: 0,
        intimation: 0,
        investigation: 0,
        medicine: 0,
        perception: 0,
        stealth: 0,
        survival: 0,
        # ????
        armor_class: 0,
        initiative: 0,
        speed: 0,
        # Hit points
        hit_points: 0,
        current_hit_points: 0,
        temporary_hit_points: 0
      }.freeze

      attr_reader :sprite_name
      attr_accessor :sprite_id

      def initialize(sprite_id: nil, options: {}, **sprite_attributes)
        @options = options
        @sprite_id = sprite_id
        if @sprite_id && exist?
          read do |sprite_data|
            sprite_attributes = sprite_data.merge(**sprite_attributes)
            # NOTE: Any conversions that need to take place before assignment, place here.
            sprite_attributes[:state] = sprite_attributes.fetch(:state, INITIAL_STATE).to_sym
            sprite_attributes[:level] = sprite_attributes.fetch(:level, INITIAL_LEVEL).to_sym
          end
        end
        @sprite_id ||= new_sprite_id
        assign_sprite_attributes sprite_attributes

        super()
      end

      def sprite_name=(name)
        @sprite_name = begin
          name = "#{name} #{sprite_id}" if name == DEFAULT_ATTRIBUTES[:sprite_name]
          transform_sprite_name(name)
        end
      end

      def to_h
        DEFAULT_ATTRIBUTES.keys.each_with_object({}) do |attr, hash|
          hash[attr] = public_send(attr)
        end
      end

      private

      attr_reader :options

      def assign_sprite_attributes(sprite_attributes)
        DEFAULT_ATTRIBUTES.each_key do |attr|
          create_attribute_for attr
          public_send(:"#{attr}=", sprite_attributes.fetch(attr, DEFAULT_ATTRIBUTES[attr]))
        end
      end

      def create_attribute_for(attr)
        # Only create attributes for those that are not already defined in, for example,
        # other mixins included in this class (e.g. Level, State, etc.).
        class_eval { attr_accessor attr } unless %i[sprite_name state level].include?(attr)
      end

      def new_sprite_id
        SecureRandom.uuid.split('-').first
      end
    end
  end
end
