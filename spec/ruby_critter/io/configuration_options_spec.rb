# frozen_string_literal: true

RSpec.describe RubyCritter::IO::ConfigurationOptions do
  subject(:configuration_options) do
    described_class.new(options: options, **configuration_options_hash)
  end

  let(:options) { {} }
  let(:configuration_options_hash) { build(:configuration_options).to_h }

  describe 'constants' do
    it 'has a DEFAULT_HOST constant' do
      expect(described_class::DEFAULT_HOST).to eq('localhost')
    end

    it 'has a DEFAULT_PORT constant' do
      expect(described_class::DEFAULT_PORT).to eq(54321)
    end

    it 'has a DEFAULT_SERVER_READ_TIMEOUT constant' do
      expect(described_class::DEFAULT_SERVER_READ_TIMEOUT).to eq(1)
    end

    it 'has a DEFAULT_CLIENT_READ_TIMEOUT constant' do
      expect(described_class::DEFAULT_CLIENT_READ_TIMEOUT).to eq(5)
    end

    it 'has a DEFAULT_READ_BLOCK_SIZE constant' do
      expect(described_class::DEFAULT_READ_BLOCK_SIZE).to eq(1024)
    end
  end

  describe '#initialize' do
    context 'when configuration options are not pssed' do
      subject(:configuration_options) do
        described_class.new(options: options)
      end

      it 'uses the default configuration options' do
        expect(described_class::CONFIGURATION_OPTION_DEFAULTS).to eq(configuration_options_hash)
      end
    end

    context 'when configuration options are pssed' do
      let(:configuration_options_hash) do
        described_class::CONFIGURATION_OPTION_DEFAULTS.keys.each_with_object({}) do |attr, hash|
          hash[attr] = "changed #{described_class::CONFIGURATION_OPTION_DEFAULTS[attr]}"
        end
      end

      it 'uses the provided configuration options' do
        expect(configuration_options.to_h).to eq(configuration_options_hash)
      end
    end
  end

  describe '#==' do
    context 'when the other object is not a ConfigurationOptions object' do
      it 'returns false' do
        expect(configuration_options == 'not a configuration options object').to be false
      end
    end

    context 'when an attribute value is different' do
      it 'returns false' do
        expect(configuration_options == described_class.new(options: options, **configuration_options_hash.merge({ host: 'different host' }))).to be false
      end
    end

    context 'when the attribute values are the same' do
      it 'returns true' do
        other_configuration_options = described_class.new(options: options, **configuration_options.to_h)
        expect(configuration_options == other_configuration_options).to be true
      end
    end
  end

  describe '#hash' do
    it 'returns the hash of the configuration options object' do
      expected_hash = configuration_options.to_h.values.map(&:hash).hash
      expect(configuration_options.hash).to eq(expected_hash)
    end
  end
end
