class AlterStocks2 < ActiveRecord::Migration
  def up
  	add_column("stocks", "id", :integer)
  end

  def down
  	remove_column("stocks", "id")
  end
end
