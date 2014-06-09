module Hectic
  module Extensions
    autoload :API, 'app/extensions/api'
    require 'app/extensions/sequel_model'
  end
end
