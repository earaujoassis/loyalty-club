module Hectic
  module Routes
    class LoyaltyPoints < Base
      get '/v1/customers/:id/points/?' do
        json LoyaltyPoint.where(:customer_id => params[:id]).ordered.map{|v| v.as_json }
      end
    end
  end
end
