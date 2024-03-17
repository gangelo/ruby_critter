# frozen_string_literal: true

FactoryBot.define do
  factory :sprite_base, class: 'RubyCritter::Sprites::SpriteBase' do
    sprite_id { SecureRandom.uuid.split('-').first }
    options { {} }
    sprite_data { {} }

    transient do
      state { RubyCritter::Sprites::SpriteBase::INITIAL_STATE }
      level { RubyCritter::Sprites::SpriteBase::INITIAL_LEVEL }
    end

    initialize_with do
      sprite_data.merge!({
        state: state,
        level: level,
        experience_points:  RubyCritter::Sprites::SpriteBase::LEVEL_RANGES[level].first
      })
      new(sprite_id: sprite_id, options: options, **sprite_data)
    end

    trait :unborn do
      state { :unborne }
    end

    trait :alive do
      state { :alive }
    end

    trait :dead do
      state { :dead }
    end

    trait :level1 do
      level { :one }
    end

    trait :level2 do
      level { :two }
    end

    trait :level3 do
      level { :three }
    end

    trait :level4 do
      level { :four }
    end

    trait :level5 do
      level { :five }
    end

    trait :level6 do
      level { :six }
    end

    trait :level7 do
      level { :seven }
    end

    trait :level8 do
      level { :eight }
    end

    trait :level9 do
      level { :nine }
    end

    trait :level10 do
      level { :ten }
    end
  end
end
