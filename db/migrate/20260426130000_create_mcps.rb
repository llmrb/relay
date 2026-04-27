Sequel.migration do
  change do
    create_table(:mcps) do
      primary_key :id
      foreign_key :user_id, :users, null: false, on_delete: :cascade
      String :name, null: false
      String :description, text: true
      String :transport, null: false, default: "stdio"
      TrueClass :enabled, null: false, default: true
      column :data, :json, null: false, default: Sequel.lit("'{}'")

      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :user_id
      index [:user_id, :enabled]
    end
  end
end
