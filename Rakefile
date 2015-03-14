#!/usr/bin/env rake

require 'dotenv/tasks'

task app: :dotenv do
  require './app'
end

namespace :server do
  socket_file = File.join ENV['HOME'], 'tmp/loyalty-club.sock'

  desc 'Start the server'
  task :start do
    `thin start -d --socket #{socket_file}`
  end

  task :stop do
    `thin stop`
    `rm -f #{socket_file}`
  end

  task :restart do
    `thin stop`
    `rm -f #{socket_file}`
    `thin start -d --socket #{socket_file}`
  end
end

namespace :db do
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
    load './db/seeds.rb'
  end
end
