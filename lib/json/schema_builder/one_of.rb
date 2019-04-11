require_relative 'entity'

module JSON
  module SchemaBuilder
    class OneOf < MaybeCollection
      def to_h
        hash_with(:oneOf)
      end
    end
  end
end
