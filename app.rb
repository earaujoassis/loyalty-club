require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'stylus/sprockets'

require 'app/extensions'
require 'app/routes'

module Hectic
  class App < Sinatra::Application
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
    use Hectic::Routes::LoyaltyPoints
  end
end
