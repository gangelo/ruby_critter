# frozen_string_literal: true

require_relative '../misc/equatable'
require_relative '../misc/hashable'

module RubyCritter
  module IO
    # Defines this gem's configuration options.
    class ConfigurationOptions
      include Misc::Equatable
      include Misc::Hashable

      DEFAULT_HOST = 'localhost'
      DEFAULT_PORT = 54321
      DEFAULT_SERVER_READ_TIMEOUT = 1
      DEFAULT_CLIENT_READ_TIMEOUT = 5
      DEFAULT_READ_BLOCK_SIZE = 1024

      CONFIGURATION_OPTION_DEFAULTS = {
        host: DEFAULT_HOST,
        port: DEFAULT_PORT,
        client_read_timeout: DEFAULT_SERVER_READ_TIMEOUT,
        server_read_timeout: DEFAULT_CLIENT_READ_TIMEOUT,
        default_read_block_size: DEFAULT_READ_BLOCK_SIZE
      }.freeze

      def initialize(options: {}, **configuration_options)
        @options = options
        create_and_assign_attrs CONFIGURATION_OPTION_DEFAULTS.dup.merge(configuration_options)
      end

      def to_h
        CONFIGURATION_OPTION_DEFAULTS.keys.each_with_object({}) do |attr, hash|
          hash[attr] = public_send(attr)
        end
      end

      private

      attr_accessor :options

      def create_and_assign_attrs(configuration_options)
        CONFIGURATION_OPTION_DEFAULTS.each_key do |attr|
          self.class.class_eval { attr_accessor attr }
          public_send(:"#{attr}=", configuration_options[attr])
        end
      end
    end
  end
end
