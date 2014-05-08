module Hectic
  module Routes
    class Customers < Base
      get '/v1/customers/?' do
        json Customer.all
      end

      get '/v1/customers/:id/?' do
        additional = { current_points: 0 }
        points = LoyaltyPoint.where(:customer_id => params[:id]).ordered.first
        additional = additional.merge(points.as_resumed_json) unless points.nil?
        json Customer.first!(:id => params[:id]).as_json.merge(additional)
      end
    end
  end
end
