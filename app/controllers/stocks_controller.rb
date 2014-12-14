class StocksController < ApplicationController
  def index
    # @stocks = Stock.order(":name ASC")

    @stocks = Stock.scoped
    @stocks = Stock.where("ticker_symbol = ?", params[:find_it][:kuken]).order("Date ASC") if params[:find_it]

    # returns an array of all the days for which info is recorded for Microsoft, 
    # with all the stats
    # @stock.daily_stats

    # returns the opening price for Microsoft today.
    # @stock.daily_stats.find_by_date(Date.today).open
  end

  def find_it
    @stocks = Stock.where("ticker_symbol = ?", params[:find_it]).order("Date ASC")
  end

  def show
  end

  def new
  end

  def edit
  end

  def delete
  end
end
