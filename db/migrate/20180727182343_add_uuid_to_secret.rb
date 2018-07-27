class AddUuidToSecret < ActiveRecord::Migration[5.1]
  def change
    add_column :secrets, :uuid, :string, index: true
    remove_index :secrets, :public_key
  end
end
