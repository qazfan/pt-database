class CreateCounters < ActiveRecord::Migration[7.0]
  def change
    create_table :counters do |t|
      t.string :name
      t.integer :visits

      t.timestamps
    end
  end
end
