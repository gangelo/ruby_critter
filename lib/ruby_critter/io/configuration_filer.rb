# frozen_string_literal: true

require 'fileutils'
require 'json'
require_relative '../os/file_system'

module RubyCritter
  module IO
    # Defines the basic file operations for the configuratjion.
    module ConfigurationFiler
      CONFIG_FILE = '.ruby_critter'

      class << self
        def included(base)
          base.extend(ClassMethods)
          base.const_set(:CONFIG_FILE, CONFIG_FILE)
        end
      end

      def save
        self.class.write(config_hash: to_h, options: options)
      end
      alias save! save

      def exist?
        self.class.exist?
      end
      alias persisted? exist?

      module ClassMethods
        def exist?
          File.exist?(config_file)
        end

        def find(options: {})
          new(options: options)
        end

        def read(options: {}) # rubocop:disable Lint/UnusedMethodArgument
          return {} unless exist?

          File.open(config_file, 'r') do |file|
            file.flock(File::LOCK_SH)

            hash = JSON.parse(file.read || {}, symbolize_names: true)

            file.flock(File::LOCK_UN)

            yield hash if block_given?

            hash
          end
        end

        def write(config_hash:, options: {}) # rubocop:disable Lint/UnusedMethodArgument
          FileUtils.mkdir_p(File.dirname(config_file))
          File.open(config_file, 'w') do |file|
            file.flock(File::LOCK_EX)

            file.puts JSON.pretty_generate(config_hash)

            file.flock(File::LOCK_UN)
          end
        end

        def config_file
          File.join(file_system.config_folder, CONFIG_FILE)
        end

        def file_system
          OS::FileSystem
        end
      end

      private

      def read
        self.class.read do |config_hash|
          yield config_hash if block_given?
        end
      end
    end
  end
end
