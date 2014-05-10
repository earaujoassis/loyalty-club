module Hectic
  module Routes
    class Base < Sinatra::Application
      configure do
        set :root, File.expand_path('../../../', __FILE__)

        disable :method_override
        disable :protection
        disable :static

        # Exceptions
        enable :use_code
        set :show_exceptions, :after_handler
      end

      register Extensions::API

      error Sequel::ValidationFailed do
        status 406
        json error: {
          type: 'validation_failed',
          messages: env['sinatra.error'].to_s
        }
      end

      error Sequel::DatabaseError do
        status 500
        json error: {
          type: 'database_error',
          messages: env['sinatra.error'].to_s
        }
      end

      error Sequel::NoMatchingRow do
        status 404
        json error: {
          type: 'unknown_record'
        }
      end
    end
  end
end
