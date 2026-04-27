Sequel.migration do
  change do
    create_table(:model_infos) do
      primary_key :id
      String :provider, null: false
      String :model_id, null: false
      String :name, null: false
      TrueClass :chat, null: false, default: false
      column :data, :json, null: false, default: Sequel.lit("'{}'")

      DateTime :synced_at, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false

      index :provider
      index [:provider, :chat]
      index [:provider, :model_id], unique: true
    end
  end
end
