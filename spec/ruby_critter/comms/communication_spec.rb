# frozen_string_literal: true

RSpec.describe RubyCritter::Comms::Communication do
  subject(:communication) do
    Class.new do
      include RubyCritter::Comms::Communication
    end.new
  end

  describe 'constants' do
    it 'has a COMMAND_BLOCK_SIZE constant' do
      expect(described_class::COMMAND_BLOCK_SIZE).to eq(1024)
    end

    context 'when included in a class' do
      it 'mixes in a COMMAND_BLOCK_SIZE constant' do
        expect(communication.class::COMMAND_BLOCK_SIZE).to eq(1024)
      end
    end
  end

  describe '.msg_nop' do
    it 'returns the nop message' do
      expect(described_class.msg_nop).to eq(op: 'nop', data: {})
    end
  end

  describe '.msg_ping' do
    it 'returns the ping message' do
      expect(described_class.msg_ping).to eq(op: 'ping', data: {})
    end
  end

  describe '.msg_quit' do
    it 'returns the quit message' do
      expect(described_class.msg_quit).to eq(op: 'quit', data: {})
    end
  end

  describe '.msg_state' do
    let(:sprite_id) { 'sprite name' }

    it 'returns the state message' do
      expect(described_class.msg_state(sprite_id: sprite_id)).to eq(op: 'state', data: { sprite_id: sprite_id })
    end
  end
end
