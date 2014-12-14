class AlterStocks < ActiveRecord::Migration
  def up
  	# add_column("stocks", "id", :integer)
  	rename_column("stocks", "date", "city")
  	rename_column("stocks", "open", "void")
  	rename_column("stocks", "high", "date")
  	rename_column("stocks", "low", "open")
  	rename_column("stocks", "close", "high")
  	rename_column("stocks", "volume", "low")
  	rename_column("stocks", "closing_price", "close")
  	rename_column("stocks", "created_at", "volume")
  	rename_column("stocks", "updated_at", "closing_price")
  	change_column("stocks", "date", :datetime)
  end

  def down
  	change_column("stocks", "date", :float)
  	rename_column("stocks", "closing_price", "updated_at")
  	rename_column("stocks", "volume", "created_at")
  	rename_column("stocks", "close", "closing_price")
  	rename_column("stocks", "low", "volume")
  	rename_column("stocks", "high", "close")
  	rename_column("stocks", "open", "low")
  	rename_column("stocks", "date", "high")
  	rename_column("stocks", "void", "open")
  	rename_column("stocks", "city", "date")
  	# remove_column("stocks", "id")

  end
end
