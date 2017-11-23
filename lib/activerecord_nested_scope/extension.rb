require_relative 'builder'

module ActiveRecordNestedScope
  module Extension
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_reader :_nested_scope_options

      def nested_scope(name, options = {})
        @_nested_scope_options ||= {}
        @_nested_scope_options[name] = options

        self.scope name, ->(args) {
          ActiveRecordNestedScope::Builder.new(self, name).build(args)
        }
      end
    end
  end
end
