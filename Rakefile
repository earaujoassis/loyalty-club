#!/usr/bin/env rake

require 'dotenv/tasks'

task app: :dotenv do
  require './app'

  Hectic::App.configure!
end

namespace :db do
  def psql_connection
    database_url = ENV['DATABASE_URL']
    database = Sequel.connect("#{database_url}postgres",
      user: ENV['DATABASE_USER'], password: ENV['DATABASE_PASSWORD'],
      encoding: 'utf-8')
  end

  desc 'Create the database'
  task :create do
    require './app'
    require 'pg'
    require 'sequel'

    database_prefix = ENV['DATABASE_NAME_PREFIX']
    database_suffix = (ENV['PROJECT_ENV'] || :development).to_sym
    database_user = ENV['DATABASE_USER']
    database_name = "#{database_prefix}_#{database_suffix}"
    database = psql_connection()
    result = database.fetch("SELECT COUNT(*) AS n FROM pg_database WHERE datname='#{database_name}'").first
    if result[:n] == 0
      database << "CREATE DATABASE #{database_name} OWNER #{database_user}"
    else
      puts "Database #{database_name} already exists; skipping"
    end
  end

  task :destroy do
    require './app'
    require 'pg'
    require 'sequel'

    database_prefix = ENV['DATABASE_NAME_PREFIX']
    database_suffix = ENV['PROJECT_ENV'].to_sym || :development
    database_name = "#{database_prefix}_#{database_suffix}"
    database = psql_connection
    database << "DROP DATABASE IF EXISTS #{database_name}"
  end

  desc 'Run DB migrations'
  task migrate: :app do
   require 'sequel/extensions/migration'

   Sequel::Migrator.apply(Hectic::App.database, 'db/migrations')
  end

  desc 'Rollback migration'
  task rollback: :app do
    require 'sequel/extensions/migration'

    database = Hectic::App.database
    version  = (row = database[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(database, 'db/migrations', version - 1)
  end

  desc 'Drop the database'
  task drop: :app do
    database = Hectic::App.database

    database.tables.each do |table|
      database.run("DROP TABLE #{table} CASCADE")
    end
  end

  desc 'Dump the database schema'
  task dump: :app do
    require 'uri'

    database = Hectic::App.database
    database_name = URI(database.url).path
    database_name.slice! '/'

    `sequel -d #{database.url} > db/schema.rb`
    `pg_dump --schema-only #{database_name} > db/schema.sql`
  end

  desc 'Load seed data into database'
  task seed: :app do
    require 'sequel/extensions/seed'

    Sequel::Seeder.apply(Hectic::App.database, 'db/seeds')
  end
end
