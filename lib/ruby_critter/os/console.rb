# frozen_string_literal: true

require 'colorize'

module RubyCritter
  module OS
    module Console
      ERROR_COLORS = { color: :red, background: :default, mode: :default }.freeze
      DEBUG_COLORS = { color: :black, background: :yellow, mode: :default }.freeze
      HIGHLIGHT_COLORS = { color: :cyan, background: :default, mode: :default }.freeze
      INFORMATION_COLORS = { color: :default, background: :default, mode: :default }.freeze
      MESSAGE_COLORS = { color: :default, background: :default, mode: :default }.freeze
      SUCCESS_COLORS = { color: :green, background: :default, mode: :default }.freeze
      WARNING_COLORS = { color: :yellow, background: :default, mode: :default }.freeze

      module_function

      def puts_prefix
        # TODO: Replace this with your message prefix.
      end

      def puts_debug(message)
        puts_message(message,
          prefix: "#{puts_prefix} Debug:",
          **DEBUG_COLORS)
      end

      def puts_error(message)
        $stderr.puts "#{puts_prefix} Error: #{message}".lstrip.colorize(**ERROR_COLORS) # rubocop:disable Style/StderrPuts
      end

      def puts_highlight(message)
        puts_message(message,
          prefix: puts_prefix,
          **HIGHLIGHT_COLORS)
      end

      def puts_information(message)
        puts_message(message,
          prefix: puts_prefix,
          **INFORMATION_COLORS)
      end
      alias puts_info puts_information

      def puts_success(message)
        puts_message(message,
          prefix: puts_prefix,
          **SUCCESS_COLORS)
      end

      def puts_warning(message)
        puts_message(message,
          prefix: puts_prefix,
          **WARNING_COLORS)
      end

      def puts_message(message,
        prefix: nil,
        color: MESSAGE_COLORS[:color],
        background: MESSAGE_COLORS[:background],
        mode: MESSAGE_COLORS[:mode])
        puts "#{prefix} #{message}".lstrip.colorize({ color: color, background: background, mode: mode })
      end
    end
  end
end
