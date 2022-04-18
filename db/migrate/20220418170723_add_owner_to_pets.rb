class AddOwnerToPets < ActiveRecord::Migration[7.0]
  def change
    add_column :pets, :owner, :string
  end
end
