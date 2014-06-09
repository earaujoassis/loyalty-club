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

      def validate
        super
        validates_presence [:full_name]
        validates_unique :full_name
      end
    end
  end
end
