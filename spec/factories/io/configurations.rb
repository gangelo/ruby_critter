# frozen_string_literal: true

FactoryBot.define do
  factory :configuration, class: 'RubyCritter::IO::Configuration' do
    configuration_options { build(:configuration_options) } # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    options { {} }

    initialize_with do
      new(options: options, **configuration_options.to_h)
    end
  end
end
