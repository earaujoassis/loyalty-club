module Hectic
  module Routes
    class Customers < Base
      get '/v1/customers/?' do
        json Customer.all
      end
    end
  end
end
