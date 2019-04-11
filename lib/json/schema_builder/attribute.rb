module JSON
  module SchemaBuilder
    module Attribute
      extend ActiveSupport::Concern

      module ClassMethods
        def attribute(name, as: nil, array: false)
          attr = as || snakeize(name)
          registered_attributes << name
          attribute_aliases.merge!(name => attr)
          define_method name do |*values|
            result = if array
              _array_attr attr, values.flatten
            else
              _attr attr, values.first
            end

            result
          end
          alias_method "#{ name }=", name
        end

        def registered_attributes
          @registered_attributes ||= begin
                                       if superclass
                                          .respond_to?(:registered_attributes)
                                         superclass.registered_attributes.dup
                                       else
                                         []
                                       end
                                     end
        end

        def attribute_aliases
          @attribute_aliases ||= begin
                                   if superclass
                                      .respond_to?(:attribute_aliases)
                                     superclass.attribute_aliases.dup
                                   else
                                     {}.with_indifferent_access
                                   end
                                 end
        end

        protected

        def snakeize(str)
          str.to_s.underscore.gsub(/_(\w)/){ $1.upcase }
        end
      end

      def attribute_values
        self.class.registered_attributes.map do |a|
          [self.class.attribute_aliases[a], send(a)]
        end.to_h
      end

      protected

      def _array_attr(attr, values = [])
        if values.empty?
          self.schema[attr] || []
        else
          self.schema[attr] ||= []
          _rename_array_values!(values)
          self.schema[attr] += values
          self.schema[attr].uniq!
          self.schema[attr]
        end
      end

      def _attr(attr, value)
        if value.nil?
          self.schema[attr]
        else
          self.schema[attr] = value
        end
      end

      def _rename_array_values!(values)
        values.each do |value|
          if value.class < Entity && value.name
            value.name = nil
            value.reset_fragment
          end
        end
      end
    end
  end
end
