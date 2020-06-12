# frozen_string_literal: true

require_relative 'lib/command_bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'command_bot'
  spec.version       = CommandBot::VERSION
  spec.authors       = ['Fizvlad']
  spec.email         = ['fizvlad@mail.ru']

  spec.summary       = 'General purpose text bots'
  spec.homepage      = 'https://github.com/fizvlad/command_bot'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.5')

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = 'https://github.com/fizvlad/command_bot'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
