# frozen_string_literal: true

module SpriteHelpers
  def generated_sprite_id
    SecureRandom.uuid.split('-').first
  end
end
