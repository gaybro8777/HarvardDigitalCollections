class AddApiKeyToUsers < ActiveRecord::Migration[5.1]
  def self.up
    change_table(:users) do |t|
      t.string :api_key
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
