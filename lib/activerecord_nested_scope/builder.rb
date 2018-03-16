module ActiveRecordNestedScope
  class Builder
    def initialize(klass, name, args)
      @klass = klass
      @name = name
      @args = args
    end

    def build
      build_for(@klass)
    end

    private

    def build_for(klass)
      if klass._nested_scope_options
        if (through = klass._nested_scope_options[@name][:through])
          if (ref = klass.reflect_on_association(through))
            build_relation(klass, ref)
          else
            raise ArgumentError.new("can't find reflection #{through} in #{klass}")
          end
        else
          root_relation(klass)
        end
      else
        klass.none
      end
    end

    def build_relation(klass, ref)
      case ref.class.to_s
      when 'ActiveRecord::Reflection::HasManyReflection', 'ActiveRecord::Reflection::HasOneReflection'
        has_many_relation(klass, ref)
      when 'ActiveRecord::Reflection::BelongsToReflection'
        if ref.polymorphic?
          belongs_to_polymorphic_relation(klass, ref)
        else
          belongs_to_relation(klass, ref)
        end
      else
        raise ArgumentError.new("unsupported reflection: #{ref} in #{klass}")
      end
    end

    def has_many_relation(klass, ref)
      klass.where(klass.primary_key => build_for(ref.klass).merge(scoped(ref.klass, ref.scope)).select(ref.foreign_key))
    end

    def belongs_to_relation(klass, ref)
      klass.where(ref.foreign_key => build_for(ref.klass).merge(scoped(ref.klass, ref.scope)).select(klass.primary_key))
    end

    def belongs_to_polymorphic_relation(klass, ref)
      types = klass.unscoped.group(ref.foreign_type).pluck(ref.foreign_type)
      if types.present?
        rels = types.map { |type|
          if (parent = type.safe_constantize)
            klass.where(ref.foreign_type => type, ref.foreign_key => build_for(parent).merge(scoped(parent, ref.scope)))
          else
            klass.none
          end
        }
        union(klass, rels)
      else
        klass.none
      end
    end

    def root_relation(klass)
      if @args.is_a?(Integer) || @args.is_a?(Array) || @args.is_a?(ActiveRecord::Base)
        klass.where(klass.primary_key => @args)
      elsif @args.is_a?(ActiveRecord::Relation)
        klass.all.merge(@args)
      elsif @args
        klass.where(@args)
      else
        klass.all
      end
    end

    def scoped(klass, scope)
      rel = klass.all
      rel = rel.instance_eval(&scope) if scope
      rel
    end

    def union(klass, rels)
      if defined? ActiveRecordUnion
        rels.reduce(:union)
      else
        union = rels.map { |rel| "#{rel.to_sql}" }.reject(&:empty?).join(' UNION ')
        klass.from(Arel.sql("(#{union}) AS #{klass.table_name}"))
      end
    end
  end
end
