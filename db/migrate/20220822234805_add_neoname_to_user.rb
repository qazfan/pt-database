class AddNeonameToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :neoname, :string
  end
end
