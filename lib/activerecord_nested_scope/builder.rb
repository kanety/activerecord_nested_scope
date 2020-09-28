module ActiveRecordNestedScope
  class Builder
    def initialize(klass, name, args)
      @node = Node.new(klass, name)
      @args = args
      @args_type = args_type(args)
    end

    def build(node = @node)
      if node.leaf?
        leaf_relation(node)
      else
        build_relation(node)
      end
    end

    private

    def build_relation(node)
      if node.has_many?
        has_many_relation(node)
      elsif node.polymorphic_belongs_to?
        polymorphic_belongs_to_relation(node)
      elsif node.belongs_to?
        belongs_to_relation(node)
      else
        raise ArgumentError.new("unsupported reflection: #{node.reflection} in #{node.klass}")
      end
    end

    def has_many_relation(node)
      child = node.children.first
      return node.klass.none unless child

      relation = child_relation(child, select: node.reflection.foreign_key)
      node.klass.where(node.reflection.active_record_primary_key => relation)
    end

    def belongs_to_relation(node)
      child = node.children.first
      return node.klass.none unless child

      relation = child_relation(child, select: node.reflection.active_record_primary_key)
      node.klass.where(node.reflection.foreign_key => relation)
    end

    def polymorphic_belongs_to_relation(node)
      rels = node.children.map do |child|
        relation = child_relation(child, select: child.klass.primary_key)
        node.klass.where(
          node.reflection.foreign_type => child.klass.to_s,
          node.reflection.foreign_key => relation
        )
      end

      union(node.klass, rels)
    end

    def child_relation(child, select:)
      if simple_leaf_relation?(child)
        @args
      else
        relation = build(child).select(select)
        relation = relation.merge(child.scope) if child.has_scope?
        relation
      end
    end

    def simple_leaf_relation?(child)
      @args_type == :simple && child.leaf? && child.parent.belongs_to? && !child.has_scope?
    end

    def leaf_relation(node)
      case @args_type
      when :relation
        node.klass.all.merge(@args)
      when :hash
        node.klass.where(@args)
      when :simple
        node.klass.where(node.klass.primary_key => @args)
      else
        raise ArgumentError.new("unexpected argument type: #{@args_type}")
      end
    end

    def args_type(args)
      if args.is_a?(ActiveRecord::Relation)
        :relation
      elsif args.is_a?(Hash)
        :hash
      else
        :simple
      end
    end

    def union(klass, rels)
      return klass.none if rels.blank?
      union = rels.map { |rel| "#{rel.to_sql}" }.reject(&:empty?).join(' UNION ')
      klass.from(Arel.sql("(#{union}) AS #{klass.table_name}"))
    end
  end
end
