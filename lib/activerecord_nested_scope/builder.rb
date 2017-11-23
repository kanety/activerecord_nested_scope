module ActiveRecordNestedScope
  class Builder
    def initialize(klass, name)
      @klass = klass
      @name = name
    end

    def build(args)
      options = @klass._nested_scope_options[@name]

      if options[:join] == true
        JoinRelationBuilder.new(@klass, @name).build(args)
      else
        SubqueryRelationBuilder.new(@klass, @name).build(args)
      end
    end
  end

  class SubqueryRelationBuilder < Builder
    def build(args)
      @args = args
      build_for(@klass)
    end

    private

    def build_for(klass)
      through = klass._nested_scope_options[@name][:through]
      if through
        ref = klass.reflect_on_association(through)
        if ref.nil?
          raise ArgumentError.new("can't find reflection #{through} in #{klass}")
        else
          build_relations(klass, ref)
        end
      else
        RootRelation.build(klass, @args)
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
            ref_klass = ref_type.safe_constantize
            klass.where(ref.foreign_type => ref_type, ref.foreign_key => build_for(ref_klass))
          }.reduce(:union)
        else
          klass.where(ref.foreign_key => build_for(ref.klass).select(klass.primary_key))
        end
      else
        raise ArgumentError.new("unexpected reflection: #{ref} in #{klass}")
      end
    end
  end

  class JoinRelationBuilder < Builder
    def build(args)
      refs = search_reflections(@klass)
      joins = refs.reverse.inject({}) { |hash, ref| { ref.name => hash } }
      @klass.joins(joins).merge(RootRelation.build(refs.last.klass, args))
    end

    private

    def search_reflections(klass, refs = [])
      through = klass._nested_scope_options[@name][:through]
      return refs unless through

      ref = klass.reflect_on_association(through)
      if ref.nil?
        raise ArgumentError.new("can't find reflection: #{through} in #{klass}")
      elsif ref.polymorphic?
        raise ArgumentError.new("can't join polymorphic association: #{through} in #{klass}")
      else
        refs << ref
        search_reflections(ref.klass, refs)
      end
    end
  end

  class RootRelation
    class << self
      def build(klass, args)
        if args.is_a?(Fixnum) || args.is_a?(ActiveRecord::Base)
          klass.where(klass.primary_key => args)
        elsif args.is_a?(ActiveRecord::Relation)
          klass.merge(args)
        elsif args
          klass.where(args)
        else
          klass.all
        end
      end
    end
  end
end
