require_relative 'entity'

module JSON
  module SchemaBuilder
    class Array < Entity
      register :array
      attribute :additional_items
      attribute :min_items
      attribute :max_items
      attribute :unique_items

      def to_h
        super.merge(items: @items.to_h)
      end

      def items(*args, &block)
        return @items if args.empty? && !block_given?

        opts = args.extract_options!
        @items = args.first || items_entity(opts, &block)
      end

      protected

      def items_entity(opts, &block)
        opts[:parent] = self
        if opts[:type]
          send opts.delete(:type), opts, &block
        else
          Entity.new(nil, opts, &block).tap(&:merge_children!)
        end
      end
    end
  end
end
