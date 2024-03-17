# frozen_string_literal: true

FactoryBot.define do
  factory :file_system, class: 'RubyCritter::OS::FileSystems' do
    critter_id { SecureRandom.uuid.split('-').last }
    options { {} }

    initialize_with do
      new(critter_id: critter_id, options: options)
    end
  end
end
