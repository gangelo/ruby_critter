# frozen_string_literal: true

RSpec.describe RubyCritter::IO::Services::StderrRedirectorService do
  describe '.call' do
    it 'captures $stderr and returns the string value' do
      string = described_class.call do
        warn 'Hello, world!'
      end

      expect(string).to eq("Hello, world!\n")
    end
  end
end
