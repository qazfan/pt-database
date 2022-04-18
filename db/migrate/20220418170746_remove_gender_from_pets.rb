class RemoveGenderFromPets < ActiveRecord::Migration[7.0]
  def change
    remove_column :pets, :gender
  end
end
