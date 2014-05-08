require './app'

module Hectic
  module TestHelpers
    def setup_db
      require 'sequel/extensions/migration'
      Sequel::Migrator.apply(Hectic::App.database, 'db/migrations')
      load './db/seeds.rb'
    end

    def teardown_db
      database = Hectic::App.database
      database.tables.each do |table|
        database.run("DROP TABLE #{table} CASCADE")
      end
    end

    def symbolize_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
            when String then key.to_sym
            else key
          end
        new_value = case value
            when Hash then symbolize_keys(value)
            else value
          end
        result[new_key] = new_value
        result
      }
    end
  end
end
