module Hectic
  module Models
    class Customer < Sequel::Model
      dataset_module do
        def ordered
          order(:created_at.desc)
        end
      end

      one_to_many :loyalty_points, :on_delete => :cascade

      def as_json(options = nil)
        {
          id: id,
          full_name: full_name,
          created_at: created_at
        }
      end

      def validate!
        if full_name.nil? || full_name.to_s.empty? || !valid?
          raise Sequel::ValidationFailed, 'Validation failed on Customer model'
        end
      end
    end
  end
end
