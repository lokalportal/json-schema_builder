require_relative 'entity'

module JSON
  module SchemaBuilder
    class Items < Entity
      # register :items

      def initialize(*args, &block)

      end

      def to_h
        hash_with(:anyOf)
      end
    end
  end
end
