# frozen_string_literal: true

module RubyCritter
  module Sprites
    module SpriteNameTransform
      TRANSFORM_NAME_REGEX = /[^a-zA-Z0-9]/
      TRANSFORM_NAME_SEPARATOR = ' '

      module_function

      def transform_sprite_name(sprite_id)
        sprite_id
          .gsub(TRANSFORM_NAME_REGEX, TRANSFORM_NAME_SEPARATOR)
          .squeeze(TRANSFORM_NAME_SEPARATOR)
      end
    end
  end
end
