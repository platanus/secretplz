class AddMessageAndSignatureToSecret < ActiveRecord::Migration[5.1]
  def change
    add_column :secrets, :message, :text
    add_column :secrets, :signature, :string
  end
end
