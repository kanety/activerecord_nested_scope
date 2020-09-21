module ActiveRecordNestedScope
  class Node
    attr_accessor :klass, :name, :parent

    def initialize(klass, name, parent = nil)
      @klass = klass
      @name = name
      @parent = parent
    end

    def has_options?
      options = @klass.nested_scope_options
      options && options[@name]
    end

    def options(key)
      (@klass.nested_scope_options.to_h[@name] || {})[key]
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

    def polymorphic_klasses
      types = @klass.unscoped.group(reflection.foreign_type).pluck(reflection.foreign_type).compact
      types.map { |type| type.safe_constantize }.compact
    end

    def children
      @children ||= search_children
    end

    def search_children
      if leaf?
        []
      elsif polymorphic_belongs_to?
        polymorphic_klasses.map { |klass| Node.new(klass, @name, self) }.select(&:valid?)
      else
        [Node.new(reflection.klass, @name, self)].select(&:valid?)
      end
    end

    def reflection_scope
      if parent && parent.reflection.scope
        @klass.all.instance_eval(&parent.reflection.scope) 
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
  end
end
