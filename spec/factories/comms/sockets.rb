# frozen_string_literal: true

FactoryBot.define do
  factory :socket, class: 'RubyCritter::Comms::Socket' do
    options { {} }

    initialize_with do
      new(options: options)
    end
  end
end
