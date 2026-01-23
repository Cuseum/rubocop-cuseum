# typed: false
# frozen_string_literal: true

require "spec_helper"

RSpec.describe RuboCop::Cop::Cuseum::SinglePublicMethodService, :config do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context "when service has zero public methods" do
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

  context "when service has one public method" do
    it "does not register an offense" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def call
            # implementation
          end

          private

          def process_user
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service has multiple public methods" do
    it "registers offenses for methods after the first" do
      expect_offense(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def call
            # first method - OK
          end

          def execute
          ^^^^^^^^^^^ Cuseum/SinglePublicMethodService: Service classes should have at most one public method.
            # second method - violation
          end

          def process
          ^^^^^^^^^^^ Cuseum/SinglePublicMethodService: Service classes should have at most one public method.
            # third method - violation
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
            # implementation
          end
        end
      RUBY
    end
  end

  context "when service has mix of public and private methods" do
    it "only counts public methods" do
      expect_no_offenses(<<~RUBY, "app/services/user_service.rb")
        class UserService < BaseService
          def call
            # only public method
            helper_method
          end

          private

          def helper_method
            # private method
          end

          def another_helper
            # another private method
          end
        end
      RUBY
    end
  end
end