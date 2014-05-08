module Hectic
  module Routes
    class Customers < Base
      get '/v1/customers/?' do
        json Customer.all.map{|v| v.as_json }
      end
    end
  end
end
