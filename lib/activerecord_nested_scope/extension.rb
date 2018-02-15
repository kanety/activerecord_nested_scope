require 'active_support'
require_relative 'builder'

module ActiveRecordNestedScope
  module Extension
    extend ActiveSupport::Concern

    included do
      class_attribute :_nested_scope_options
    end

    class_methods do
      def nested_scope(name, options = {})
        self._nested_scope_options ||= {}
        self._nested_scope_options[name] = options

        self.scope name, ->(args) {
          ActiveRecordNestedScope::Builder.new(self, name).build(args)
        }
      end
    end
  end
end
