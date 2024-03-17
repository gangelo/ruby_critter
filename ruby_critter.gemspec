# frozen_string_literal: true

require_relative 'lib/ruby_critter/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_critter'
  spec.version       = RubyCritter::VERSION
  spec.authors       = ['Gene M. Angelo, Jr.']
  spec.email         = ['public.gma@gmail.com']

  spec.summary       = 'Creates a virtual ruby critter (pet).'
  spec.description   = 'Creates a virtual ruby critter (pet) you need to take care of.'
  spec.homepage      = 'https://github.com/gangelo/ruby_critter'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0.1', '< 4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/gangelo/ruby_critter/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 7.0.8', '< 8.0'
  spec.add_dependency 'activesupport', '>= 7.0.8', '< 8.0'
  spec.add_dependency 'aasm', '>= 5.5', '< 6.0'
  spec.add_dependency 'colorize', '>= 1.1', '< 2.0'
  spec.add_dependency 'thor', '>= 1.2', '< 2.0'

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.post_install_message = <<~POST_INSTALL
    Thank you for installing ruby_critter.

    View the ruby_critter README.md here: https://github.com/gangelo/ruby_critter
    View the ruby_critter CHANGELOG.md: https://github.com/gangelo/ruby_critter/blob/main/CHANGELOG.md

                *
               ***
             *******
            *********
     ***********************
        *****************
          *************
         ******* *******
        *****       *****
       ***             ***
      **                 **

    Using ruby_critter? ruby_critter is made available free of charge. Please consider giving this gem a STAR on GitHub as well as sharing it with your fellow developers on social media.

    Knowing that ruby_critter is being used and appreciated is a great motivator to continue developing and improving ruby_critter.

    >>> Star it on github: https://github.com/gangelo/ruby_critter
    >>> Share on social media: https://rubygems.org/gems/ruby_critter

    Thank you!

    <3 Gene
  POST_INSTALL
  spec.metadata['rubygems_mfa_required'] = 'true'
end
