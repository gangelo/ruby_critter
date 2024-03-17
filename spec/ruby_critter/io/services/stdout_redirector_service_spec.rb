# frozen_string_literal: true

RSpec.describe RubyCritter::IO::Services::StdoutRedirectorService do
  describe '.call' do
    it 'captures $stdout and returns the string value' do
      string = described_class.call do
        puts 'Hello, world!'
      end

      expect(string).to eq("Hello, world!\n")
    end
  end
end
