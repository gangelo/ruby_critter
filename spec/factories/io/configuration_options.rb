# frozen_string_literal: true

FactoryBot.define do
  factory :configuration_options, class: 'RubyCritter::IO::ConfigurationOptions' do
    configuration_options { {} }
    options { {} }

    initialize_with do
      new(options: options, **configuration_options)
    end
  end
end
