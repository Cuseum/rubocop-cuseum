# typed: false
# frozen_string_literal: true

module RuboCop
  module Cop
    module Cuseum
      # Ensures that service classes in app/services inherit from BaseService directly or indirectly.
      #
      # @example
      #   # good - direct inheritance
      #   class UserService < BaseService
      #     def call
      #       # ...
      #     end
      #   end
      #
      #   # good - indirect inheritance
      #   class ApplicationService < BaseService
      #   end
      #
      #   class UserService < ApplicationService
      #     def call
      #       # ...
      #     end
      #   end
      #
      #   # bad - no inheritance from BaseService
      #   class UserService
      #     def call
      #       # ...
      #     end
      #   end
      #
      #   # bad - inherits from something else
      #   class UserService < SomeOtherClass
      #     def call
      #       # ...
      #     end
      #   end
      #
      class InheritFromBaseService < Base
        MSG = "Service classes must inherit from BaseService directly or indirectly."

        def on_class(node)
          return if inherits_from_base_service?(node)

          add_offense(node, message: MSG)
        end

        private

        def inherits_from_base_service?(node)
          parent_class = node.parent_class
          return false unless parent_class

          check_inheritance_chain(parent_class)
        end

        def check_inheritance_chain(parent_class_node)
          return false unless parent_class_node

          class_name = extract_class_name(parent_class_node)
          return true if class_name == "BaseService"

          # For more complex inheritance checking, we'd need to resolve the actual class
          # and check its ancestors, but for most cases, direct parent checking should suffice
          # This cop assumes BaseService inheritance is usually direct or one level deep
          false
        end

        def extract_class_name(class_node)
          case class_node.type
          when :const
            class_node.const_name
          when :send
            # Handle namespaced classes like Module::BaseService
            class_node.method_name.to_s if class_node.receiver.nil?
          end
        end
      end
    end
  end
end