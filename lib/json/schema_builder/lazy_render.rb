module JSON
  module SchemaBuilder
    module LazyRender
      def to_h
        if (coll = MaybeCollection.wrap(self)) == self
          base_to_h.merge(
            attribute_values
            .transform_keys(&:to_sym)
            .transform_values(&bool_preserve_presence)
            .compact
          )
        else
          coll.to_h
        end
      end

      protected

      def base_to_h
        self.class == Entity ? {} : { 'type' => implied_type }
      end

      def implied_type
        self.class.name.demodulize.underscore
      end

      # false#presence => nil so we have to make some exceptions
      def bool_preserve_presence
        ->(val) { val == false ? val : val.presence }
      end
    end
  end
end
