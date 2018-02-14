require 'active_support'
require_relative 'builder'

module ActiveRecordNestedScope
  module Extension
    def self.included(base)
      base.class_attribute :_nested_scope_options
      base.extend(ClassMethods)
    end

    module ClassMethods
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
