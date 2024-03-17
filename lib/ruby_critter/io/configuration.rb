# frozen_string_literal: true

require_relative '../misc/equatable'
require_relative '../misc/hashable'
require_relative 'configuration_filer'
require_relative 'configuration_options'

module RubyCritter
  module IO
    # Defines this gem's configuration file.
    class Configuration
      include ConfigurationFiler
      include Misc::Equatable
      include Misc::Hashable

      delegate :host, :port, :client_read_timeout,
        :server_read_timeout, :default_read_block_size, to: :configuration_options

      def initialize(options: {}, **configuration_options)
        @options = options

        if exist?
          set_configuration_options(**configuration_options)
        else
          set_configuration_options_and_save!(**configuration_options)
        end
      end

      def to_h
        # NOTE: If any other configuration attributes are added that
        # are not included in ConfigurationOptions, they should be
        # added here.
        configuration_options.to_h
      end

      private

      attr_accessor :configuration_options, :options

      def set_configuration_options(**configuration_options)
        return unless exist?

        read do |configuration_options_hash|
          merged_configuration_options = configuration_options_hash.merge(configuration_options)
          self.configuration_options = ConfigurationOptions.new(options: options, **merged_configuration_options)
        end
      end

      def set_configuration_options_and_save!(**configuration_options)
        self.configuration_options = ConfigurationOptions.new(options: options, **configuration_options)

        save
      end
    end
  end
end
