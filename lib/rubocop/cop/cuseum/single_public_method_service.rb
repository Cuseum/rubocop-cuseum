# typed: false
# frozen_string_literal: true

module RuboCop
  module Cop
    module Cuseum
      # Ensures that service classes in app/services have at most one public method.
      #
      # @example
      #   # good - zero public methods
      #   class UserService < BaseService
      #     private
      #
      #     def process_user
      #       # ...
      #     end
      #   end
      #
      #   # good - one public method
      #   class UserService < BaseService
      #     def call
      #       # ...
      #     end
      #
      #     private
      #
      #     def process_user
      #       # ...
      #     end
      #   end
      #
      #   # bad - multiple public methods
      #   class UserService < BaseService
      #     def call
      #       # ...
      #     end
      #
      #     def execute  # ← should be private
      #       # ...
      #     end
      #   end
      #
      class SinglePublicMethodService < Base
        MSG = "Service classes should have at most one public method."

        def on_class(node)
          public_methods = extract_public_methods(node)

          # Allow 0 or 1 public methods, flag 2 or more
          return if public_methods.size <= 1

          public_methods.each_with_index do |method_node, index|
            next if index.zero? # Allow the first public method

            add_offense(method_node, message: MSG)
          end
        end

        private

        def extract_public_methods(class_node)
          public_methods = []
          current_visibility = :public

          if class_node.body
            if class_node.body.begin_type?
              # Multiple statements in class body
              class_node.body.each_child_node do |child|
                case child.type
                when :send
                  if visibility_modifier?(child)
                    current_visibility = child.method_name
                  end
                when :def
                  if current_visibility == :public && regular_method?(child)
                    public_methods << child
                  end
                end
              end
            else
              # Single statement in class body (likely a single method)
              child = class_node.body
              case child.type
              when :send
                if visibility_modifier?(child)
                  current_visibility = child.method_name
                end
              when :def
                if current_visibility == :public && regular_method?(child)
                  public_methods << child
                end
              end
            end
          end

          public_methods
        end

        def visibility_modifier?(node)
          return false unless node.send_type?

          [:private, :protected, :public].include?(node.method_name) &&
            node.receiver.nil? &&
            node.arguments.empty?
        end

        def regular_method?(method_node)
          return false unless method_node.def_type?

          method_name = method_node.method_name.to_s
          # Exclude initialize and special methods
          method_name != "initialize" &&
            !method_name.start_with?("initialize") &&
            !method_name.match?(/^[^a-zA-Z]/)
        end
      end
    end
  end
end