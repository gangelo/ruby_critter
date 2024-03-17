# frozen_string_literal: true

RSpec.describe RubyCritter::IO::ConfigurationFiler do
  subject(:configuration) do
    described_class.new(host: host, port: port, options: options)
  end

  describe 'constants' do
    it 'defines a CONFIG_FILE constant' do
      expect(described_class::CONFIG_FILE).to eq('.ruby_critter')
    end
  end
end
