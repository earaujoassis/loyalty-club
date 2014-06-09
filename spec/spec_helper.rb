ENV['RACK_ENV'] = 'test'
require './app'
require 'rspec'
require 'rack/test'
require 'uuid'
require 'faker'
require 'factory_girl'

def setup_db
  require 'sequel/extensions/migration'
  Sequel::Migrator.apply(Hectic::App.database, File.join('db', 'migrations'))
end

def reset_db
  database = Hectic::App.database
  database.tables.each do |table|
    database.run("DROP TABLE IF EXISTS #{table} CASCADE")
  end
end

def ensure_db!
  db_name = Hectic::App.database.opts[:database]
  unless db_name =~ /_testing\d*$/
    puts "Test database name must end with '_testing'. Database name: #{db_name}"
    exit(1)
  end
  reset_db
  setup_db
end

ensure_db!
DB = Hectic::App.database

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  #config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods
  config.around(:each, transaction: nil) do |example|
    DB.transaction(rollback: :always){ example.run }
  end
  config.before(:suite) do
    Dir.glob(File.join('spec', 'factories', '**', '*.rb')).each { |f| require f }
  end
end

Sequel::Model.send(:alias_method, :save!, :save)
