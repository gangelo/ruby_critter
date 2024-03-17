# frozen_string_literal: true

module StdxxxHelpers
  def strip_escapes(escaped_string)
    escaped_string.gsub(/\e\[[0-9;]*[a-zA-Z]/, '')
  end

  def capture_stdout_and_strip_escapes(&block)
    strip_escapes(RubyCritter::IO::Services::StdoutRedirectorService.call(&block).chomp)
  end

  def capture_stderr_and_strip_escapes(&block)
    strip_escapes(RubyCritter::IO::Services::StderrRedirectorService.call(&block).chomp)
  end
end
