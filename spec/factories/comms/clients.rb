# frozen_string_literal: true

FactoryBot.define do
  factory :client, class: 'RubyCritter::Comms::Client' do
    configuration { build(:configuration) } # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    socket { build(:socket) } # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    options { {} }

    initialize_with do
      new(configuration: configuration, socket: socket, options: options)
    end
  end
end
