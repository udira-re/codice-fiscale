# frozen_string_literal: true

require_relative "lib/codice_fiscale/version"

Gem::Specification.new do |spec|
  spec.name        = "codicefiscale_ruby"
  spec.version     = CodiceFiscale::VERSION
  spec.authors     = ["Amshu Pokharel"]
  spec.email       = ["pokharelamshu@gmail.com"]

  spec.summary     = "Generate and validate Italian and foreign Codice Fiscale"
  spec.description = <<~DESC
    A Ruby gem to generate Codice Fiscale for Italian and foreign individuals
    and validate given CF codes.
  DESC

  spec.homepage    = "https://github.com/udira-re/codice-fiscale"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"]     = spec.homepage
  spec.metadata["source_code_uri"]  = "https://github.com/udira-re/CF-gem-.git"
  spec.metadata["changelog_uri"]    = "https://github.com/udira-re/codice-fiscale/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
