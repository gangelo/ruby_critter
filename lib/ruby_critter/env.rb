# frozen_string_literal: true

# Defines the various environments that RubyCritter can run in.
module RubyCritter
  Env = Struct.new(:env) do
    def environment
      env.fetch('RUBY_CRITTER_ENV', '(not set)')
    end

    def test?
      env.fetch('RUBY_CRITTER_ENV', nil) == 'test'
    end

    def development?
      env.fetch('RUBY_CRITTER_ENV', nil) == 'development'
    end

    def local?
      test? || development?
    end

    def production?
      env.fetch('RUBY_CRITTER_ENV', 'production') == 'production'
    end

    def screen_shot_mode?
      development? && (env.fetch('SCREEN_SHOT_USERNAME', '').present? ||
        env.fetch('SCREEN_SHOT_HOSTNAME', '').present?)
    end

    def screen_shot_prompt
      username = screen_shot_username
      hostname = screen_shot_hostname
      "#{username}@#{hostname}:~ $"
    end

    def screen_shot_username
      env.fetch('SCREEN_SHOT_USERNAME', 'username')
    end

    def screen_shot_hostname
      env.fetch('SCREEN_SHOT_HOSTNAME', 'hostname')
    end
  end

  class << self
    def env
      @env ||= Env.new(ENV)
    end
  end
end
