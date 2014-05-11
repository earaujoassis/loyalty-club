module Hectic
  module Routes
    class Customers < Base
      get '/v1/customers/?' do
        json Customer.ordered.all
      end

      get '/v1/customers/:id/?' do
        json Customer.first!(:id => params[:id])
      end

      post '/v1/customers/?' do
        customer = Customer.new
        customer.set_fields(params, [:full_name])
        customer.validate!
        customer.save
        json customer
      end

      put '/v1/customers/:id/?' do
        customer = Customer.first!(:id => params[:id])
        customer.update(full_name: params[:full_name])
        json customer
      end
    end
  end
end
