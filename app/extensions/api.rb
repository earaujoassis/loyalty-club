module Hectic
  module Extensions
    module API extend self
      module Helpers
        def json(value, options = {})
          content_type :json
          value.to_json(options)
        end
      end

      def registered(app)
        app.helpers Helpers
      end
    end
  end
end
