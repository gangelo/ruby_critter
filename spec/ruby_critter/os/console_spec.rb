# frozen_string_literal: true

RSpec.describe RubyCritter::OS::Console do
  subject(:console) do
    Class.new do
      include RubyCritter::OS::Console
    end
  end

  describe 'constants' do
    it 'has an ERROR_COLORS constant' do
      expect(described_class.const_defined?(:ERROR_COLORS)).to be true
    end

    it 'has a HIGHLIGHT_COLORS constant' do
      expect(described_class.const_defined?(:HIGHLIGHT_COLORS)).to be true
    end

    it 'has an INFORMATION_COLORS constant' do
      expect(described_class.const_defined?(:INFORMATION_COLORS)).to be true
    end

    it 'has a MESSAGE_COLORS constant' do
      expect(described_class.const_defined?(:MESSAGE_COLORS)).to be true
    end

    it 'has a SUCCESS_COLORS constant' do
      expect(described_class.const_defined?(:SUCCESS_COLORS)).to be true
    end

    it 'has a WARNING_COLORS constant' do
      expect(described_class.const_defined?(:WARNING_COLORS)).to be true
    end
  end

  describe '.puts_prefix' do
    it 'returns nil unless overridden' do
      expect(described_class.puts_prefix).to be_nil
    end
  end

  describe '.puts_debug' do
    it 'puts a debug message' do
      expect(
        capture_stdout_and_strip_escapes do
          described_class.puts_debug('message')
        end
      ).to include('Debug: message')
    end
  end

  describe '.puts_error' do
    it 'puts an error message to stderr' do
      expect(
        capture_stderr_and_strip_escapes do
          described_class.puts_error('message')
        end
      ).to include('Error: message')
    end
  end

  describe '.puts_highlight' do
    it 'puts a highlighted message' do
      expect(
        capture_stdout_and_strip_escapes do
          described_class.puts_highlight('message')
        end
      ).to include('message')
    end
  end

  describe '.puts_information' do
    it 'puts an informational message' do
      expect(
        capture_stdout_and_strip_escapes do
          described_class.puts_information('message')
        end
      ).to include('message')
    end
  end

  describe '.puts_success' do
    it 'puts a success message' do
      expect(
        capture_stdout_and_strip_escapes do
          described_class.puts_success('message')
        end
      ).to include('message')
    end
  end

  describe '.puts_warning' do
    it 'puts a warning message' do
      expect(
        capture_stdout_and_strip_escapes do
          described_class.puts_warning('message')
        end
      ).to include('message')
    end
  end
end
