# frozen_string_literal: true

require 'fileutils'
require 'json'
require_relative '../os/file_system'

module RubyCritter
  module IO
    # Defines the basic file operations for a sprite.
    module SpriteFiler
      class << self
        def included(base)
          base.extend(ClassMethods)
        end
      end

      def save
        self.class.write(sprite_id: sprite_id, sprite_hash: to_h, options: options)
      end
      alias save! save

      def exist?
        self.class.exist?(sprite_id: sprite_id, options: options)
      end
      alias persisted? exist?

      module ClassMethods
        SPRITE_FILE_NAME = 'sprite.json'

        def exist?(sprite_id:, options: {})
          sprite_file = sprite_file(sprite_id: sprite_id, options: options)

          File.exist?(sprite_file)
        end

        def find(sprite_id:, options: {})
          unless exist?(sprite_id: sprite_id, options: options)
            raise Errors::SpriteNotFound, "Sprite not found: \"#{sprite_id}\""
          end

          new(options: options, sprite_id: sprite_id)
        end

        def read(sprite_id:, options: {})
          return {} unless exist?(sprite_id: sprite_id)

          sprite_file = sprite_file(sprite_id: sprite_id, options: options)
          File.open(sprite_file, 'r') do |file|
            file.flock(File::LOCK_SH)

            hash = JSON.parse(file.read || {}, symbolize_names: true)

            file.flock(File::LOCK_UN)

            hash = yield hash if block_given?

            hash
          end
        end

        def write(sprite_id:, sprite_hash:, options: {})
          sprite_file = sprite_file(sprite_id: sprite_id, options: options)
          FileUtils.mkdir_p(File.dirname(sprite_file))
          File.open(sprite_file, 'w') do |file|
            file.flock(File::LOCK_EX)

            file.puts JSON.pretty_generate(sprite_hash)

            file.flock(File::LOCK_UN)
          end
        end

        def sprite_file(sprite_id:, options: {})
          File.join(file_system(sprite_id: sprite_id, options: options).sprite_folder, SPRITE_FILE_NAME)
        end

        def file_system(sprite_id:, options: {})
          OS::FileSystem.new(sprite_id: sprite_id, options: options)
        end
      end

      private

      def read
        self.class.read(sprite_id: sprite_id, options: options) do |sprite_hash|
          yield sprite_hash if block_given?
        end
      end
    end
  end
end
