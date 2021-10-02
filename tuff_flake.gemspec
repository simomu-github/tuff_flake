# frozen_string_literal: true

require_relative "lib/tuff_flake/version"

Gem::Specification.new do |spec|
  spec.name          = "tuff_flake"
  spec.version       = TuffFlake::VERSION
  spec.authors       = ["simomu"]
  spec.email         = ["simomutter@gmail.com"]

  spec.summary       = "id generator like snowflake"
  spec.description   = "id generator like snowflake"
  spec.homepage      = "https://github.com/simomu-github"
  spec.required_ruby_version = ">= 2.7.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/simomu-github/tuff_flake"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rspec"
  spec.add_dependency "rubocop"
  spec.add_dependency "rubocop-rspec"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
