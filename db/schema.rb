Sequel.migration do
  change do
    create_table(:customers, ignore_index_errors: true) do
      String :id, null: false
      Integer :iid, null: false
      String :full_name, text: true
      DateTime :created_at
      DateTime :updated_at

      primary_key [:id]

      index [:iid], unique: true
    end

    create_table(:schema_info) do
      Integer :version, default: 0, null: false
    end

    create_table(:loyalty_points, ignore_index_errors: true) do
      String :id, null: false
      Integer :iid, null: false
      foreign_key :customer_id, :customers, type: String, key: [:id]
      String :description, text: true
      Integer :previous_points, default: 0
      Integer :current_points, default: 0
      DateTime :created_at
      DateTime :updated_at

      primary_key [:id]

      index [:iid], unique: true
    end
  end
end
