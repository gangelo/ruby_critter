# frozen_string_literal: true

require 'active_support/all'
require 'fileutils'
require 'i18n'
require 'thor'
require 'time'

I18n.load_path += Dir[File.join(__dir__, 'locales/**/*', '*.yml')]
# I18n.default_locale = :en # (note that `en` is already the default!)

require_relative 'ruby_critter/env'
puts "Environment is: #{RubyCritter.env.environment}"
require 'pry-byebug' if RubyCritter.env.local?

require 'pry-byebug'

Dir.glob("#{__dir__}/ruby_critter/**/*.rb").each { |file| require file }

module RubyCritter
  # Defines the main namespace for this gem.

  module Errors
    class Error < StandardError; end
    class SpriteNotFound < Errno::ENOENT; end
    class SpriteAlreadyExists < Errno::EEXIST; end
  end
end

FileUtils.mkdir_p(RubyCritter::OS::FileSystem.home_folder)
