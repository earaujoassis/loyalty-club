Sequel.default_timezone = :utc
Sequel.extension :core_extensions
Sequel.extension :pg_array
Sequel.extension :pg_array_ops
Sequel::Model.raise_on_save_failure = false
Sequel::Model.plugin :timestamps
Sequel::Model.plugin :serialization
Sequel::Model.plugin :validation_helpers
Sequel::Plugins::Serialization.register_format(:json,
  lambda{|v| v.as_json },
  lambda{|v| JSON.parse(v, :symbolize_names => true) }
)
Sequel::Plugins::Serialization.register_format(:pg_uuid_array,
  lambda{|v| Sequel::Postgres::PGArray.new(v, :uuid) },
  lambda{|v| Sequel::Postgres::PGArray::Parser.new(v).parse }
)
Sequel::Postgres::PGArray.register('uuid', :type_symbol => :string)

module Hectic
  module Models
    autoload :Customer, 'app/models/customer'
    autoload :LoyaltyPoint, 'app/models/loyalty_point'
  end
end
