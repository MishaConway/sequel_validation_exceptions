module Sequel
  class ValidationException < RuntimeError
    attr_reader :validation_errors

    def initialize validation_errors
      @validation_errors = validation_errors
    end
  end

  module Plugins
    module ValidationExceptions
      module ClassMethods
        def create! attributes={}
          instance = self.new attributes
          instance.save!
          instance
        end

        def find_or_create! cond, &block
          find(cond) || create!(cond, &block)
        end
      end

      module InstanceMethods
        def save! *columns
          success = save *columns
          if !success
            raise ValidationException.new(errors), "Could not save #{id.nil? ? 'new' : ''} #{self.class.name} model #{id} due to failing validation: #{errors.inspect}\n\tmodel was: #{inspect}"
          end
        end

        def update! *columns
          success = update *columns
          if !success
            raise ValidationException.new(errors), "Could not update #{id.nil? ? 'new' : ''} #{self.class.name} model #{id} due to failing validation: #{errors.inspect}\n\tmodel was: #{inspect}"
          end
        end
      end
    end
  end
end
