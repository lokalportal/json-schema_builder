
module JSON
  module SchemaBuilder
    class MaybeCollection
      class << self
        def wrap(object)
          return object unless (wrapper = present_wrapper(object))

          collection_attributes[wrapper].new(
            *wrap_content(object, wrapper)
          )
        end

        def wrap_content(object, wrapper)
          duplicate = object.deep_dup
          others = duplicate.send(wrapper).dup
          duplicate.send("#{wrapper}=", others.dup)
          duplicate.send(wrapper).clear
          others << duplicate unless object.class == Entity
          others.compact.flatten
        end

        def present_wrapper(object)
          collection_attributes
            .keys.find { |a| object.send(a).present? }
        end

        def collection_attributes
          @collection_attributes ||= {
            any_of: AnyOf,
            all_of: AllOf,
            one_of: OneOf
          }.freeze
        end
      end

      attr_reader :items

      def initialize(*items)
        @items = items
      end

      def hash_with(key)
        {
          key => items.map(&:to_h).uniq.reject(&:blank?)
        }
      end
    end
  end
end
