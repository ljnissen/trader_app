class CompaniesAndStocksController < ApplicationController
  def index
    @companies_and_stocks = CompaniesAndStock.find_by_id(1)

    @companies_and_stock.daily_stats
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
