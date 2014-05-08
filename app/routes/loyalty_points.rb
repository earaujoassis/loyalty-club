module Hectic
  module Routes
    class LoyaltyPoints < Base
      get '/v1/customers/:id/points/?' do
        json LoyaltyPoint.where(:customer_id => params[:id]).ordered
      end

      get '/v1/customers/:id/current_points/?' do
        json LoyaltyPoint.where(:customer_id => params[:id]).ordered.limit(1)
      end

      post '/v1/customers/:id/points/?' do
        customer = Customer.first!(:id => params[:id])
        latest_transaction = LoyaltyPoint.where(:customer_id => params[:id]).ordered.limit(1)
        transaction = LoyaltyPoint.new
        transaction.previous_points = latest_transaction.current_points
        transaction.current_points = transaction.previous_points + params[:balance].to_i
        transaction.customer = customer
        transaction.set_fields(params, [:description])
        transaction.save
        json transaction
      end

      put '/v1/customers/:customer/points/:id/?' do
        transaction = LoyaltyPoint.first!(:id => params[:id])
        transaction.update(description: params[:description])
        json transaction
      end
    end
  end
end
