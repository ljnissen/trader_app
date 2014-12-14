class CreateDailyStats < ActiveRecord::Migration
  def change
    create_table :daily_stats do |t|

      t.timestamps
    end
  end
end
