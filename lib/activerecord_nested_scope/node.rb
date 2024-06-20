# frozen_string_literal: true

module ActiveRecordNestedScope
  class Node
    attr_accessor :klass, :name, :parent, :source_type

    def initialize(klass, name, parent = nil, source_type = nil)
      @klass = klass
      @name = name
      @parent = parent
      @source_type = source_type
    end

    def has_options?
      options = @klass.nested_scope_options
      options && options[@name]
    end

    def options(key)
      options = @klass.nested_scope_options.to_h
      options.dig(@name, key)
    end

    def reflection
      @klass.reflect_on_association(options(:through))
    end

    def leaf?
      options(:through).blank?
    end

    def has_many?
      reflection.class.name.in?(['ActiveRecord::Reflection::HasManyReflection', 'ActiveRecord::Reflection::HasOneReflection'])
    end

    def belongs_to?
      reflection.class.name == 'ActiveRecord::Reflection::BelongsToReflection' && !reflection.polymorphic?
    end

    def polymorphic_belongs_to?
      reflection.class.name == 'ActiveRecord::Reflection::BelongsToReflection' && reflection.polymorphic?
    end

    def children
      @children ||= search_children.select(&:valid?)
    end

    def search_children
      if leaf?
        []
      elsif polymorphic_belongs_to?
        types = PolymorphicType.new(self, reflection).resolve
        types.map { |klass, source_type| Node.new(klass, @name, self, source_type) }
      else
        [Node.new(reflection.klass, @name, self)]
      end
    end

    def valid?
      return false unless has_options?

      if options(:through) && !reflection
        STDERR.puts "can't find reflection for #{options(:through)} in #{klass}"
        return false
      end

      return true
    end

    def has_scope?
      @parent && @parent.reflection.scope.present?
    end

    def scope
      @klass.all.instance_eval(&@parent.reflection.scope) if has_scope?
    end

    class PolymorphicType
      def initialize(node, reflection)
        @node = node
        @reflection = reflection
      end

      def resolve
        types = @node.klass.unscoped.group(@reflection.foreign_type).pluck(@reflection.foreign_type).compact
        types.map do |type|
          klass = resolve_source_type(type)&.safe_constantize
          [klass, type] if klass
        end.compact
      end

      private

      def resolve_source_type(type)
        if (map = @node.options(:source_map))
          resolve_from_map(type, map)
        else
          type
        end
      end

      def resolve_from_map(type, map)
        if map.is_a?(Proc)
          map.call(type)
        elsif map.is_a?(Hash)
          map[type]
        else
          raise ArgumentError.new("unsupported argument type for source_map option: #{map.class}.")
        end
      end
    end
  end
end
