class IndexCountersOnVisits < ActiveRecord::Migration[7.0]
  def change
    add_index :counters, :visits
  end
end
