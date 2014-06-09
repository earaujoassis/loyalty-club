module Sequel
  class Model
    def validate!
      validate
      raise Sequel::ValidationFailed, 'Model is not valid' unless valid?
    end
  end
end
