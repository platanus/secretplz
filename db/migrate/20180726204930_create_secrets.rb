class CreateSecrets < ActiveRecord::Migration[5.1]
  def change
    create_table :secrets do |t|
      t.string :public_key, index: true

      t.timestamps
    end
  end
end
