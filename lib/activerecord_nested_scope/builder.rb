module ActiveRecordNestedScope
  class Builder
    def initialize(klass, name)
      @klass = klass
      @name = name
    end

    def build(args)
      @args = args
      build_for(@klass)
    end

    private

    def build_for(klass)
      if klass._nested_scope_options
        if (through = klass._nested_scope_options[@name][:through])
          if (ref = klass.reflect_on_association(through))
            build_relations(klass, ref)
          else
            raise ArgumentError.new("can't find reflection #{through} in #{klass}")
          end
        else
          RootRelation.build(klass, @args)
        end
      else
        klass.none
      end
    end

    def build_relations(klass, ref)
      case ref.class.to_s
      when 'ActiveRecord::Reflection::HasManyReflection', 'ActiveRecord::Reflection::HasOneReflection'
        klass.where(klass.primary_key => build_for(ref.klass).select(ref.foreign_key))
      when 'ActiveRecord::Reflection::BelongsToReflection'
        if ref.polymorphic?
          ref_types = klass.unscoped.group(ref.foreign_type).pluck(ref.foreign_type)
          ref_types.map { |ref_type|
            if (ref_klass = ref_type.safe_constantize)
              klass.where(ref.foreign_type => ref_type, ref.foreign_key => build_for(ref_klass))
            else
              klass.none
            end
          }.reduce(:union)
        else
          klass.where(ref.foreign_key => build_for(ref.klass).select(klass.primary_key))
        end
      else
        raise ArgumentError.new("unexpected reflection: #{ref} in #{klass}")
      end
    end
  end

  class RootRelation
    class << self
      def build(klass, args)
        if args.is_a?(Integer) || args.is_a?(ActiveRecord::Base)
          klass.where(klass.primary_key => args)
        elsif args.is_a?(ActiveRecord::Relation)
          klass.all.merge(args)
        elsif args
          klass.where(args)
        else
          klass.all
        end
      end
    end
  end
end
