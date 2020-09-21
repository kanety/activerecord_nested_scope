module ActiveRecordNestedScope
  class Node
    attr_accessor :klass, :name, :parent

    def initialize(klass, name, parent = nil)
      @klass = klass
      @name = name
      @parent = parent
      validate
    end

    def through
      options[:through]
    end

    def reflection
      @klass.reflect_on_association(through)
    end

    def leaf?
      through.blank?
    end

    def has_many?
      reflection.class.name.in?(['ActiveRecord::Reflection::HasManyReflection', 'ActiveRecord::Reflection::HasOneReflection'])
    end

    def belongs_to?
      reflection.class.name == 'ActiveRecord::Reflection::BelongsToReflection'
    end

    def polymorphic_belongs_to?
      belongs_to? && reflection.polymorphic?
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
        polymorphic_klasses.map { |klass| Node.new(klass, @name, self) }
      else
        [Node.new(reflection.klass, @name, self)]
      end
    end

    def reflection_scope
      if parent && parent.reflection.scope
        @klass.all.instance_eval(&parent.reflection.scope) 
      end
    end

    private

    def options
      @klass.nested_scope_options[@name]
    end

    def validate
      if options.nil?
        raise ArgumentError.new("can't find nested_scope for #{@name} in #{klass}")
      end
      if through && !reflection
        raise ArgumentError.new("can't find reflection for #{through} in #{klass}")
      end
    end
  end
end
