require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'
require 'sinatra/assetpack'
require 'active_support/json'
require 'sass'

require 'app/models'
require 'app/extensions'
require 'app/routes'

module Hectic
  class App < Sinatra::Application
    class << self
      def database=(url)
        @database = nil
        @database_url = url
        database
      end

      def database
        @database ||=
          Sequel.connect(@database_url,
              user: ENV['DATABASE_USER'],
              password: ENV['DATABASE_PASSWORD'],
              encoding: 'utf-8')
        @database
      end

      def configure!
        database_url = ENV['DATABASE_URL']
        database_prefix = ENV['DATABASE_NAME_PREFIX']
        database_suffix = ENV['PROJECT_ENV'].to_sym || :development
        self.database = "#{database_url}#{database_prefix}_#{database_suffix}"
        self
      end
    end

    configure do
      disable :method_override
      disable :static

      set :sessions,
          httponly:     true,
          secure:       production?,
          expire_after: 31557600, # 1 year
          secret:       ENV['SESSION_SECRET']
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
