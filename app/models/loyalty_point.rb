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
          description: description || '',
          previous_points: previous_points,
          current_points: current_points,
          created_at: created_at
        }
      end

      def as_resumed_json(options = nil)
        {
          previous_points: previous_points,
          current_points: current_points
        }
      end

      def validate
        super
        validates_presence [:previous_points, :current_points]
        validates_integer [:previous_points, :current_points]
        if !(previous_points >= 0 && current_points >= 0) || (previous_points + current_points < 0)
          errors.add(:current_points, 'Cannot redeem more points than the customer has in its current balance')
        end
      end
    end
  end
end
