module Hectic
  module Routes
    class LoyaltyPoints < Base
      get '/v1/customers/:id/points/?' do
        Customer.first!(id: params[:id])
        json LoyaltyPoint.where(customer_id: params[:id]).ordered
      end

      get '/v1/customers/:id/points/latest/?' do
        Customer.first!(id: params[:id])
        json LoyaltyPoint.where(customer_id: params[:id]).ordered.first!
      end

      post '/v1/customers/:id/points/?' do
        latest_transaction = LoyaltyPoint.where(customer_id: params[:id]).ordered.first
        balance = params[:balance].to_i
        customer = Customer.first!(id: params[:id])
        transaction = LoyaltyPoint.new
        unless latest_transaction.nil?
          transaction.previous_points = latest_transaction.current_points
        else
          transaction.previous_points = 0
        end
        transaction.current_points = transaction.previous_points + balance
        transaction.customer = customer
        transaction.set_fields(params, [:description])
        transaction.validate!
        transaction.save
        json transaction
      end

      put '/v1/customers/:customer/points/:id/?' do
        transaction = LoyaltyPoint.first!(id: params[:id], customer_id: params[:customer])
        transaction.update(description: params[:description])
        json transaction
      end
    end
  end
end
