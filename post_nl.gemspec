# frozen_string_literal: true

require_relative "lib/post_nl/version"

Gem::Specification.new do |spec|
  spec.name          = "post_nl"
  spec.version       = PostNL::VERSION
  spec.authors       = ["Adam Dullenty"]
  spec.email         = ["adamdullenty@bloomandwild.com"]

  spec.summary       = "A carrier integration gem for the PostNL shipping API"
  spec.homepage      = "https://github.com/BloomAndWild/post-nl"
  spec.license       = "Proprietary"

  spec.required_ruby_version = ">= 3.1.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "faraday", "~> 1.0"
end
