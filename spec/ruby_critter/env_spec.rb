# frozen_string_literal: true

RSpec.describe RubyCritter::Env do
  subject(:env) { described_class.new(ENV) }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('RUBY_CRITTER_ENV').and_return(env_value)
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('RUBY_CRITTER_ENV', nil).and_return(env_value)
  end

  let(:env_value) { nil }

  describe '#environment' do
    let(:env_value) { 'test' }

    it 'returns the environment' do
      expect(env.environment).to eq('test')
    end
  end

  describe '#test?' do
    let(:env_value) { 'test' }

    it 'returns true' do
      expect(env.test?).to be(true)
    end

    context 'when the environment is not test' do
      let(:env_value) { 'development' }

      it 'returns false' do
        expect(env.test?).to be(false)
      end
    end
  end

  describe '#development?' do
    let(:env_value) { 'development' }

    it 'returns true' do
      expect(env.development?).to be(true)
    end

    context 'when the environment is not development' do
      let(:env_value) { 'production' }

      it 'returns false' do
        expect(env.development?).to be(false)
      end
    end
  end

  describe '#local?' do
    context 'when the environment is test' do
      let(:env_value) { 'test' }

      it 'returns true' do
        expect(env.local?).to be(true)
      end

      context 'when the environment is not local' do
        let(:env_value) { 'production' }

        it 'returns false' do
          expect(env.local?).to be(false)
        end
      end
    end

    context 'when the environment is development' do
      let(:env_value) { 'development' }

      it 'returns true' do
        expect(env.local?).to be(true)
      end
    end

    context 'when the environment is not test or development' do
      let(:env_value) { 'production' }

      it 'returns false' do
        expect(env.local?).to be(false)
      end
    end
  end

  describe '#production?' do
    let(:env_value) { 'production' }

    it 'returns false' do
      expect(env.production?).to be(false)
    end

    context 'when the environment is not production' do
      let(:env_value) { 'test' }

      it 'returns false' do
        expect(env.production?).to be(false)
      end
    end
  end

  describe '#screen_shot_mode?' do
    context 'when the environment is development and the username or hostname are present' do
      before do
        allow(ENV).to receive(:fetch).with('SCREEN_SHOT_USERNAME', '').and_return('')
        allow(ENV).to receive(:fetch).with('SCREEN_SHOT_HOSTNAME', '').and_return('hostname')
      end

      let(:env_value) { 'development' }

      it 'returns true' do
        expect(env.screen_shot_mode?).to be(true)
      end
    end

    context 'when the environment is not development' do
      let(:env_value) { 'production' }

      it 'returns false' do
        expect(env.screen_shot_mode?).to be(false)
      end
    end

    context 'when the environment is development and the username and hostname are not present' do
      before do
        allow(ENV).to receive(:[]).with('SCREEN_SHOT_USERNAME').and_return(nil)
        allow(ENV).to receive(:[]).with('SCREEN_SHOT_HOSTNAME').and_return(nil)
      end

      let(:env_value) { 'development' }

      it 'returns false' do
        expect(env.screen_shot_mode?).to be(false)
      end
    end
  end

  describe '#screen_shot_prompt' do
    context 'when SCREEN_SHOT_USERNAME and SCREEN_SHOT_HOSTNAME are set' do
      before do
        allow(ENV).to receive(:fetch).with('SCREEN_SHOT_USERNAME', 'username').and_return('abcdefg')
        allow(ENV).to receive(:fetch).with('SCREEN_SHOT_HOSTNAME', 'hostname').and_return('1234567')
      end

      it 'returns the screen shot prompt' do
        expect(env.screen_shot_prompt).to eq('abcdefg@1234567:~ $')
      end
    end

    context 'when SCREEN_SHOT_USERNAME and SCREEN_SHOT_HOSTNAME are not set' do
      it 'returns the default screen shot prompt' do
        expect(env.screen_shot_prompt).to eq('username@hostname:~ $')
      end
    end
  end

  describe '#screen_shot_username' do
    context 'when SCREEN_SHOT_USERNAME is set' do
      before do
        allow(ENV).to receive(:fetch).with('SCREEN_SHOT_USERNAME', 'username').and_return('abcdefg')
      end

      it 'returns the screen shot username' do
        expect(env.screen_shot_username).to eq('abcdefg')
      end
    end

    context 'when SCREEN_SHOT_USERNAME is not set' do
      it 'returns the default screen shot username' do
        expect(env.screen_shot_username).to eq('username')
      end
    end
  end

  describe '#screen_shot_hostname' do
    context 'when SCREEN_SHOT_HOSTNAME is set' do
      before do
        allow(ENV).to receive(:fetch).with('SCREEN_SHOT_HOSTNAME', 'hostname').and_return('1234567')
      end

      it 'returns the screen shot hostname' do
        expect(env.screen_shot_hostname).to eq('1234567')
      end
    end

    context 'when SCREEN_SHOT_HOSTNAME is not set' do
      it 'returns the default screen shot hostname' do
        expect(env.screen_shot_hostname).to eq('hostname')
      end
    end
  end
end
