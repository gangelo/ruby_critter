# frozen_string_literal: true

FactoryBot.define do
  factory :critter, class: 'RubyCritter::Sprites::Critter' do
    sprite_data { {} }

    initialize_with do
      new(options: options, **sprite_data)
    end
  end
end
