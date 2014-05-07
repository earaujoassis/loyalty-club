module Hectic
  module Routes
    class LoyaltyPoints < Base
      get '/v1/costumer/:id/points/' do
        json 'hello world'
      end
    end
  end
end
