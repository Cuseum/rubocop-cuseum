# typed: false
# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rubocop-cuseum"
  spec.version = "0.1.0"
  spec.authors = ["Cuseum Team"]
  spec.email = ["dev@cuseum.com"]

  spec.summary = "RuboCop extension for Cuseum service class conventions"
  spec.description = "Custom RuboCop cops to enforce Cuseum service class patterns and best practices"
  spec.homepage = "https://github.com/cuseum/rubocop-cuseum"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "README.md",
    "LICENSE.txt",
    "config/default.yml",
    "lib/**/*.rb"
  ]
  
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency "rubocop", ">= 1.0"

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", ">= 12.0"
  spec.add_development_dependency "rspec", ">= 3.0"
end