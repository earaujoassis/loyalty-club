module Hectic
  module Routes
    class Index < Sinatra::Application
      register Sinatra::AssetPack

      configure do
        set :views, 'app/views'
        set :root, File.expand_path('../../../', __FILE__)
        disable :method_override
        disable :static
        disable :protection
        set :erb, escape_html: false
      end

      assets do
        css :application, []
        css_compression :sass
      end

      get /\A((\/\Z)|\/customers)/ do
        erb :index
      end
    end
  end
end
