Sequel.migration do
  change do
    run %{
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    }

    create_table(:customers) do
      column :id, 'uuid', :default => Sequel::LiteralString.new('uuid_generate_v4()'), :null => false
      column :iid, :serial, :null => false
      column :full_name, 'text'
      column :created_at, 'timestamp without time zone'
      column :updated_at, 'timestamp without time zone'

      primary_key [:id]
      index [:iid], :unique => true
    end

    create_table(:loyalty_points) do
      column :id, 'uuid', :default => Sequel::LiteralString.new('uuid_generate_v4()'), :null => false
      column :iid, 'serial', :null => false
      foreign_key :customer_id, :customers, :type => 'uuid', :key => [:id]
      column :description, 'text'
      column :previous_points, 'integer', :default => 0
      column :current_points, 'integer', :default => 0
      column :created_at, 'timestamp without time zone'
      column :updated_at, 'timestamp without time zone'

      primary_key [:id]
      index [:iid], :unique => true
    end
  end
end
