require_relative 'entity'

module JSON
  module SchemaBuilder
    class Object < Entity
      register :object
      attribute :min_properties
      attribute :max_properties
      attribute :additional_properties
      attribute :pattern_properties

      def to_h
        base = super
        return base if hash_collection?(base)

        base.merge(
          { required: required }
          .transform_values(&:presence)
          .symbolize_keys
          .compact
        ).reverse_merge(properties: {})
      end

      def attribute_values
        super.merge(properties: properties)
      end

      def hash_collection?(hash)
        %i[anyOf allOf oneOf].any? { |k| hash.key?(k) }
      end

      def initialize_children
        return
        self.properties = { }

        children.select(&:name).each do |child|
          case child.name
          when Regexp
            self.pattern_properties ||= { }
            self.pattern_properties[child.name.source] = child.as_json
          else
            self.properties[child.name] = child.as_json
          end
        end
        build_any_of if @nullable
      end

      def extract_types
        initialize_children
        super
      end

      def reinitialize
        return unless initialized?
        extract_types
      end
    end
  end
end
