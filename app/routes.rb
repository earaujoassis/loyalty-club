module Hectic
  module Routes
    I18n.config.enforce_available_locales = true
    autoload :Base, 'app/routes/base'
    autoload :Static, 'app/routes/static'
    autoload :Index, 'app/routes/index'
    autoload :Customers, 'app/routes/customers'
    autoload :LoyaltyPoints, 'app/routes/loyalty_points'
  end
end
