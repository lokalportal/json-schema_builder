require_relative 'maybe_collection'

module JSON
  module SchemaBuilder
    class AllOf < MaybeCollection
      def to_h
        hash_with(:allOf)
      end
    end
  end
end
