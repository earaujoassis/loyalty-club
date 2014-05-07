module Hectic
  module Routes
    class Index < Sinatra::Application
      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)
        disable :method_override
        disable :static
        disable :protection
        set :erb, escape_html: true
      end

      register Hectic::Extensions::Assets

      get /\A((\/\Z))/ do
        erb :index
      end
    end
  end
end
