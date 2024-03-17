# frozen_string_literal: true

RSpec.describe RubyCritter::IO::Configuration do
  subject(:configuration) do
    described_class.new(options: options, **configuration_options)
  end

  shared_examples 'the configuration file does not exist' do
    it 'does not exist' do
      expect(described_class.exist?).to be false
    end
  end

  shared_examples 'the configuration file exists' do
    it 'exists' do
      expect(described_class.exist?).to be true
    end
  end

  let(:options) { {} }
  let(:configuration_options) { build(:configuration_options).to_h }

  describe '#initialize' do
    context 'when the configuration file does not exist' do
      it_behaves_like 'the configuration file does not exist'

      it 'saves the configuration file' do
        expect(configuration).to exist
      end
    end

    context 'when the configuration file exists' do
      before do
        configuration
      end

      it_behaves_like 'the configuration file exists'

      it 'loads the configuration file' do
        expect(configuration.to_h).to eq(RubyCritter::IO::ConfigurationOptions::CONFIGURATION_OPTION_DEFAULTS)
      end
    end
  end

  describe '#==' do
    context 'when the other object is not a Configuration object' do
      it 'returns false' do
        expect(configuration == 'not a configuration').to be false
      end
    end

    context 'when any of the other attribute values are different' do
      it 'returns false' do
        expect(configuration == described_class.new(options: options, host: 'different host')).to be false
      end
    end

    context 'when the attribute values are the same' do
      it 'returns true' do
        other_configuration = described_class.new(options: options, **build(:configuration_options).to_h)
        expect(configuration == other_configuration).to be true
      end
    end
  end

  describe '#exist?' do
    context 'when the configuration file exists' do
      it 'returns true' do
        expect(configuration).to exist
      end
    end

    context 'when the configuration file does not exist' do
      it_behaves_like 'the configuration file does not exist'

      it "returns true because the configuration is saved if it doesn't exist" do
        expect(configuration).to exist
      end
    end
  end

  describe '#find' do
    context 'when the configuration file exists' do
      before do
        configuration
      end

      it_behaves_like 'the configuration file exists'

      it 'returns the configuration' do
        expect(described_class.find).to eq(configuration)
      end
    end

    context 'when the configuration file does not exist' do
      it_behaves_like 'the configuration file does not exist'

      it 'returns the configuration because it is created if it does not exist' do
        expect(described_class.find).to eq(configuration)
      end
    end
  end

  describe '#hash' do
    it 'returns the hash of the configuration' do
      expected_hash = configuration.to_h.values.map(&:hash).hash
      expect(configuration.hash).to eq(expected_hash)
    end
  end
end
