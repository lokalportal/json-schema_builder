require_relative 'maybe_collection'

module JSON
  module SchemaBuilder
    class AnyOf < MaybeCollection
      def to_h
        hash_with(:anyOf)
      end
    end
  end
end
