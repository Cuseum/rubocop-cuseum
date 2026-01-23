# typed: false
# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Cuseum::InheritFromBaseService, :config do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context "when service inherits directly from BaseService" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def call
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service has no inheritance" do
    it "registers an offense" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService
        ^^^^^^^^^^^^^^^^^ Cuseum/InheritFromBaseService: Service classes must inherit from BaseService directly or indirectly.
          def call
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service inherits from another class" do
    it "registers an offense" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < SomeOtherClass
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cuseum/InheritFromBaseService: Service classes must inherit from BaseService directly or indirectly.
          def call
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service inherits from ApplicationService (which could inherit from BaseService)" do
    it "registers an offense (current limitation - doesn't check indirect inheritance)" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < ApplicationService
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cuseum/InheritFromBaseService: Service classes must inherit from BaseService directly or indirectly.
          def call
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service inherits from namespaced BaseService" do
    it "registers an offense (only checks simple class names for now)" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < Module::BaseService
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cuseum/InheritFromBaseService: Service classes must inherit from BaseService directly or indirectly.
          def call
            # implementation
          end
        end
      RUBY
    end
  end

  context "when class is empty" do
    it "still registers offense if no inheritance" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService
        ^^^^^^^^^^^^^^^^^ Cuseum/InheritFromBaseService: Service classes must inherit from BaseService directly or indirectly.
        end
      RUBY
    end
  end

  context "when class inherits from BaseService but is empty" do
    it "does not register offense" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
        end
      RUBY
    end
  end
end