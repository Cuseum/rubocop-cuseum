# typed: false
# frozen_string_literal: true

require "rubocop"
require "rubocop/rspec/support"

require_relative "../lib/rubocop-cuseum"

RSpec.configure do |config|
  config.include RuboCop::RSpec::ExpectOffense
end