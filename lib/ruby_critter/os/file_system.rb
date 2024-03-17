# frozen_string_literal: true

require_relative '../env'

module RubyCritter
  module OS
    # Defines the location of folders and files.
    class FileSystem
      SPRITES_FOLDER = 'sprites'
      DEVELOPMENT_HOME_FOLDER = '.development_home'
      HOME_FOLDER = 'ruby_critter'

      attr_reader :sprite_id

      def initialize(sprite_id:, options: {})
        @sprite_id = sprite_id
        @options = options
      end

      def sprite_folder
        self.class.sprite_folder(sprite_id: sprite_id)
      end

      # root_folder
      #   \home_folder
      #     \sprites_folder
      #       \<sprite_id 1>
      #       \<sprite_id 2>
      #       \<sprite_id ...>
      class << self
        def home_folder
          File.join(root_folder, HOME_FOLDER)
        end

        def sprite_folder(sprite_id:)
          File.join(home_folder, SPRITES_FOLDER, sprite_id)
        end

        def config_folder
          root_folder
        end

        private

        def root_folder
          return File.join(gem_dir, DEVELOPMENT_HOME_FOLDER) if RubyCritter.env.development?

          Dir.home
        end

        def gem_dir
          Gem.loaded_specs['ruby_critter'].gem_dir
        end
      end

      private

      attr_writer :sprite_id
      attr_accessor :options
    end
  end
end
