class AddSealeadAtToSecret < ActiveRecord::Migration[5.1]
  def change
    add_column :secrets, :sealed_at, :datetime
  end
end
