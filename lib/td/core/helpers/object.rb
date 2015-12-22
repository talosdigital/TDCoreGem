require 'time'
require 'active_support/core_ext/string'

module TD
  module Core
    module Helpers
      module Object
        def self.included(inclusive_class)
          inclusive_class.extend ClassMethods
        end

        def to_hash_without_nils
          return instance_variables.each_with_object({}) do |var, hash|
            if(instance_variable_get(var))
              hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
            end
          end
        end

        def copy(obj)
          return unless obj.instance_of?(self.class)
          obj.instance_variables.each do |inst_var|
            instance_variable_set(inst_var, obj.instance_variable_get(inst_var))
          end
        end
      end

      module ClassMethods
        def camelize_attributes(hash, lower = true)
          return unless hash.is_a?(Hash)
          string_hash = hash.stringify_keys
          camelize_params = lower ? :lower : :upper
          result = {}
          string_hash.each do |key, value|
            result[key.camelize(camelize_params)] = value
          end
          result.symbolize_keys
        end

        def underscore_attributes(hash)
          return unless hash.is_a?(Hash)
          string_hash = hash.stringify_keys
          result = {}
          string_hash.each do |key, value|
            result[key.underscore] = value
          end
          result.symbolize_keys
        end

        def parse_date(date)
          return date if date.is_a?(Date)
          begin
            Date.parse(date)
          rescue TypeError, ArgumentError
            nil
          end
        end

        def format_date(date)
          return date if date.is_a?(String) && parse_date(date)
          begin
            date.strftime("%Y-%m-%d")
          rescue NoMethodError
            nil
          end
        end
      end
    end
  end
end
