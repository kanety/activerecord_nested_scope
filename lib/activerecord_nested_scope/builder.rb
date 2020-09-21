module ActiveRecordNestedScope
  class Builder
    def initialize(klass, name, args)
      @node = Node.new(klass, name)
      @args = args
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
      relation = child_relation(child, select: node.reflection.foreign_key)
      node.klass.where(node.klass.primary_key => relation)
    end

    def belongs_to_relation(node)
      child = node.children.first
      relation = child_relation(child, select: node.reflection.klass.primary_key)
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
      relation = build(child)
      relation = relation.merge(child.reflection_scope) if child.reflection_scope
      relation.select(select)
    end

    def leaf_relation(node)
      if @args.is_a?(ActiveRecord::Relation)
        node.klass.all.merge(@args)
      elsif @args.is_a?(Hash)
        node.klass.where(@args)
      elsif @args
        node.klass.where(node.klass.primary_key => @args)
      else
        node.klass.none
      end
    end

    def union(klass, rels)
      return klass.none if rels.blank?
      union = rels.map { |rel| "#{rel.to_sql}" }.reject(&:empty?).join(' UNION ')
      klass.from(Arel.sql("(#{union}) AS #{klass.table_name}"))
    end
  end
end
