# typed: false
# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc "Run RuboCop on the lib directory"
task :rubocop do
  sh "rubocop lib"
end

task default: [:spec, :rubocop]