class CreateSecretParts < ActiveRecord::Migration[5.1]
  def change
    create_table :secret_parts do |t|
      t.references :secret, foreign_key: true, index: true
      t.string :key
      t.text :encrypted_data
    end
  end
end
