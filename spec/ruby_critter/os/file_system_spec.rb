# frozen_string_literal: true

RSpec.describe RubyCritter::OS::FileSystem do
  subject(:file_system) do
    described_class.new(sprite_id: sprite_id, options: options)
  end

  shared_examples 'the resource starts with the development home folder' do
    before do
      allow(described_class).to receive(:root_folder).and_call_original
      allow(RubyCritter.env).to receive(:development?).and_return(true)
    end

    it 'begins with the development home folder' do
      gem_dir = Gem.loaded_specs['ruby_critter'].gem_dir
      development_home_folder = File.join(gem_dir, described_class::DEVELOPMENT_HOME_FOLDER)
      expect(subject).to start_with(development_home_folder)
    end
  end

  let(:options) { {} }
  let(:sprite_id) { 'Sprite name' }

  describe 'constants' do
    describe 'SPRITES_FOLDER' do
      it 'returns the sprites folder' do
        expect(described_class::SPRITES_FOLDER).to eq('sprites')
      end
    end

    describe 'DEVELOPMENT_HOME_FOLDER' do
      it 'returns the development home folder' do
        expect(described_class::DEVELOPMENT_HOME_FOLDER).to eq('.development_home')
      end
    end

    describe 'HOME_FOLDER' do
      it 'returns the home folder' do
        expect(described_class::HOME_FOLDER).to eq('ruby_critter')
      end
    end
  end

  describe '#initialize' do
    it 'instantiates an instance of the class' do
      expect(file_system).to_not be_nil
    end
  end

  describe '#sprite_folder' do
    context 'when the ENV is development' do
      subject(:sprite_folder) { file_system.sprite_folder }

      it_behaves_like 'the resource starts with the development home folder'
    end

    context 'when the ENV is not development' do
      it 'returns the sprites folder' do
        expected_folder = "#{described_class.home_folder}/#{described_class::SPRITES_FOLDER}/#{sprite_id}"
        expect(file_system.sprite_folder).to eq(expected_folder)
      end
    end
  end

  describe 'class methods' do
    describe '.sprite_folder' do
      subject(:sprite_folder) { described_class.sprite_folder(sprite_id: sprite_id) }

      context 'when the ENV is development' do
        it_behaves_like 'the resource starts with the development home folder'
      end

      context 'when the ENV is not development' do
        it 'returns the sprites folder' do
          expected_folder = "#{described_class.home_folder}/#{described_class::SPRITES_FOLDER}/#{sprite_id}"
          expect(sprite_folder).to eq(expected_folder)
        end
      end
    end

    describe '.home_folder' do
      subject(:home_folder) { described_class.home_folder }

      context 'when the ENV is development' do
        it_behaves_like 'the resource starts with the development home folder'
      end

      context 'when the ENV is not development' do
        it 'returns the home folder' do
          expected_folder = "#{temp_folder}/#{described_class::HOME_FOLDER}"
          expect(described_class.home_folder).to eq(expected_folder)
        end
      end
    end

    describe '.config_folder' do
      subject(:config_folder) { described_class.config_folder }

      context 'when the ENV is development' do
        it_behaves_like 'the resource starts with the development home folder'
      end

      context 'when the ENV is not development' do
        it 'returns the config folder' do
          expect(described_class.config_folder).to eq(temp_folder)
        end
      end
    end
  end
end
