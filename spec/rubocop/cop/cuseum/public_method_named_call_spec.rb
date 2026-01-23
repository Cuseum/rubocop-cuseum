# typed: false
# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Cuseum::PublicMethodNamedCall, :config do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context "when service has no public methods" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          private

          def process_user
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service has one public method named 'call'" do
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

  context "when service has one public method with wrong name" do
    it "registers an offense" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def execute
          ^^^^^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # wrong method name
          end
        end
      RUBY
    end
  end

  context "when service has multiple public methods" do
    it "registers offenses for all methods not named 'call'" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def call
            # correct name - no offense
          end

          def execute
          ^^^^^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # wrong name
          end

          def process
          ^^^^^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # wrong name
          end
        end
      RUBY
    end
  end

  context "when service has multiple methods all with wrong names" do
    it "registers offenses for all public methods" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def execute
          ^^^^^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # wrong name
          end

          def process
          ^^^^^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # wrong name
          end

          def run
          ^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # wrong name
          end
        end
      RUBY
    end
  end

  context "when service has initialize method" do
    it "ignores initialize method" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def initialize(user)
            @user = user
          end

          def call
            # correct public method
          end
        end
      RUBY
    end
  end

  context "when service has mix of public and private methods" do
    it "only checks public methods" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def call
            # correct public method
            helper_method
          end

          private

          def helper_method
            # private method - ignored
          end

          def execute
            # private method - ignored even though wrong name
          end
        end
      RUBY
    end
  end

  context "when service changes visibility mid-class" do
    it "respects visibility modifiers" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def execute
          ^^^^^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # public method with wrong name
          end

          private

          def process
            # now private - ignored
          end

          public

          def run
          ^^^^^^^ Cuseum/PublicMethodNamedCall: Public methods in service classes should be named "call".
            # back to public with wrong name
          end
        end
      RUBY
    end
  end

  context "when class is empty" do
    it "does not register offense" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
        end
      RUBY
    end
  end
end