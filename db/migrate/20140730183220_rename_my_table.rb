class RenameMyTable < ActiveRecord::Migration
  def up
  	create_table :stocks, :id => false do |t|
  		t.column "name", :string
  		t.column "ticker_symbol", :string
  		t.column "sector", :string
  		t.column "date", :datetime
  		t.column "open", :float
  		t.column "high", :float
  		t.column "low", :float
  		t.column "close", :float
  		t.column "volume", :float
  		t.column "closing_price", :float

  		t.timestamps
    end
  end

  def down
    drop_table :stocks

  end
end
