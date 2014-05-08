module Hectic
  module Models
    class LoyaltyPoint < Sequel::Model
      dataset_module do
        def ordered
          order(:created_at.desc)
        end
      end

      many_to_one :customer

      def as_json(options = nil)
        {
          id: id,
          description: description,
          previous_points: previous_points,
          current_points: current_points,
          created_at: created_at
        }
      end
    end
  end
end
