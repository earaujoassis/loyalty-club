require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'stylus/sprockets'

require 'app/models'
require 'app/extensions'
require 'app/routes'

module Hectic
  class App < Sinatra::Application
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/monocle_#{environment}"
      }
    end

    configure do
      disable :method_override
      disable :static

      set :sessions,
          :httponly     => true,
          :secure       => production?,
          :expire_after => 31557600, # 1 year
          :secret       => ENV['SESSION_SECRET']
    end

    use Rack::Deflater

    use Hectic::Routes::Static
    use Hectic::Routes::Index
    use Hectic::Routes::Customers
    use Hectic::Routes::LoyaltyPoints
  end
end

# To easily access models in the console
include Hectic::Models
