# STEP 3/3
# This reads from .csv files in SUBDIR_DATA and builds out several tables
# in an already existing sp500-data.sqlite file

# PRE: This reads from an existing file called sp500-data.sqlite
# which should have a `companies` table
#
# POST: This downloads .csv files for every company in `companies`
#
# NOTE: This script took about an 15 minutes to run

require 'rubygems'
require 'sqlite3'

SUBDIR = 'data-hold'
SUBDIR_DATA = "#{SUBDIR}/yahoo-data"

DBNAME = "#{SUBDIR}/sp500-data.sqlite"
DB = SQLite3::Database.new( DBNAME )
C_FIELDS = %w(name ticker_symbol sector city state)
S_FIELDS = %w(date open high low close volume closing_price)

DATE_FD_INDEX = (S_FIELDS).index('date')
DB.execute("DROP TABLE IF EXISTS stock_prices;")
DB.execute("DROP TABLE IF EXISTS companies_and_stocks;")

DB.execute("CREATE TABLE stock_prices(#{S_FIELDS.map{|f| f=~/date/ ? f : "#{f} NUMERIC" }.join(',')}, company_id INTEGER)")
DB.execute("CREATE TABLE companies_and_stocks(#{(C_FIELDS+S_FIELDS).map{|f| f=~/date|name|ticker_symbol|sector|city|state|date/ ? f : "#{f} NUMERIC" }.join(',')})")

## Make company ID hash for faster reference
## companies table must already exist
co_ids = DB.execute("SELECT id, ticker_symbol FROM companies GROUP BY ticker_symbol").inject({}) do |hsh, c|
  hsh[c[1].to_s] = c[0].to_i
  hsh 
end


s_insert_sql = "INSERT INTO stock_prices VALUES(#{(S_FIELDS.length+1).times.map{'?'}.join(',')})"
cns_insert_sql = "INSERT INTO companies_and_stocks(#{(C_FIELDS+S_FIELDS).join(',')}) VALUES(#{(C_FIELDS+S_FIELDS).map{'?'}.join(',')})"

insert_sp_stmt = DB.prepare(s_insert_sql)
cns_stmt = DB.prepare(cns_insert_sql)




## Build out tables

# 'ABT', 'ABBV', 'ACE', 'ACN', 'ACT', 'ADBE', 'ADT', 'AES', 'AET', 'AFL', 'A', 'GAS', 'APD', 'ARG', 'AKAM', 'AA', 'ALXN', 'ATI', 'ALLE', 'AGN', 'ADS', 'ALL', 'ALTR', 'MO', 'AMZN', 'AEE', 'AEP', 'AXP', 'AIG', 'AMT', 'AMP', 'ABC', 'AMGN', 'APH', 'APC', 'ADI', 'AON', 'APA', 'AIV', 'AAPL', 'AMAT', 'ADM', 'AIZ', 'T', 'ADSK', 'ADP', 'AN', 'AZO', 'AVGO', 'AVB', 'AVY', 'BHI', 'BLL', 'BAC', 'BK', 'BCR', 'BAX', 'BBT', 'BDX', 'BBBY', 'BMS', 'BRK-B', 'BBY', 'BIIB', 'BLK', 'HRB', 'BA', 'BWA', 'BXP', 'BSX', 'BMY', 'BRCM', 'BF-B', 'CHRW', 'CA', 'CVC', 'COG', 'CAM', 'CPB', 'COF', 'CAH', 'CFN', 'KMX', 'CCL', 'CAT', 'CBG', 'CBS', 'CELG', 'CNP', 'CTL', 'CERN', 'CF', 'SCHW', 'CHK', 'CVX', 'CMG', 'CB', 'CI', 'CINF', 'CTAS', 'CSCO', 'C', 'CTXS', 'CLX', 'CME', 'CMS', 'COH', 'KO', 'CCE', 'CTSH', 'CL', 'CMCSA', 'CMA', 'CSC', 'CAG', 'COP', 'CNX', 'ED', 'STZ', 'GLW', 'COST', 'COV', 'CCI', 'CSX', 'CMI', 'CVS', 'DHI', 'DHR', 'DRI', 'DVA', 'DE', 'DLPH', 'DAL', 'DNR', 'XRAY', 'DVN', 'DO', 'DTV', 'DFS', 'DISCA', 'DG', 'D', 'DOV', 'DOW', 'DPS', 'DTE', 'DD', 'DUK', 'DNB', 'ETFC', 'EMN', 'ETN', 'EBAY', 'ECL', 'EIX', 'EW', 'EA', 'EMC', 'EMR', 'ESV', 'ETR', 'EOG', 'EQT', 'EFX', 'EQR', 'ESS', 'EL', 'EXC', 'EXPE', 'EXPD', 'ESRX', 'XOM', 'FFIV','FDO', 'FAST', 'FDX', 'FIS', 'FITB', 'FSLR', 'FE', 'FISV', 'FLIR', 'FLS', 'FLR', 'FMC', 'FTI','FOSL', 'BEN', 'FCX', 'FTR', 'GME', 'GCI', 'GRMN', 'GD', 'GE', 'GGP', 'GIS', 'GM', 'GPC', 'GNW', 'GILD', 'GS', 'GT', 'GOOG', 'GOOGL', 'GWW', 'HAL', 'HOG', 'HAR', 'HRS', 'HIG', 'HAS', 'HCP', 'HCN', 'HP', 'HES', 'HPQ', 'HD', 'HON', 'HRL', 'HSP', 'HST', 'HCBK', 'HUM', 'HBAN', 'ITW', 'IR', 'TEG', 'INTC', 'ICE', 'IBM', 'IGT', 'IP', 'IPG', 'IFF', 'INTU', 'ISRG', 'IVZ', 'IRM', 'JBL', 'JEC', 'JNJ', 'JCI', 'JOY', 'JPM', 'JNPR', 'KSU', 'K', 'KEY', 'GMCR', 'KMB', 'KIM', 'KMI', 'KLAC', 'KSS', 'KRFT', 'KR', 'LB', 'LLL', 'LH', 'LRCX', 'LM', 'LEG', 'LEN', 'LUK', 'LLY', 'LNC', 'LLTC', 'LMT', 'L', 'LO', 'LOW', 'LYB', 'MTB', 'MAC', 'M', 'MMM', 'MRO', 'MPC', 'MAR', 'MMC', 'MAS', 'MA', 'MAT', 'MKC', 'MCD', 'MHFI', 'MCK', 'MJN', 'MWW', 'MDT', 'MRK', 'MET', 'MCHP', 'MU', 'MSFT','TAP', 'MDLZ', 'MON', 'MNST', 'MCO', 'MS', 'MOS', 'MSI', 'MUR', 'MYL', 'NBR', 'NDAQ', 'NOV', 'NAVI', 'NTAP','NWL', 'NEM', 'NWSA', 'NEE', 'NLSN', 'NKE', 'NI', 'NE', 'NBL', 'JWN', 'NSC', 'NTRS', 'NOC', 'NU', 'NRG', 'NUE', 'NVDA', 'KORS', 'ORLY', 'OXY', 'OMC', 'OKE', 'ORCL', 'OI', 'PCG', 'PCAR', 'PLL', 'PH', 'PDCO', 'PAYX', 'BTU', 'PNR', 'PNR', 'PBCT', 'POM', 'PEP', 'PKI', 
# 'PETM', 'PFE', 'PM', 'PSX', 'PNW', 'PXD', 'PBI', 'PCL', 'PNC', 'RL', 'PPG', 'PPL', 'PX', 'PCP', 'PCLN', 'PFG', 'PG', 'PGR', 'PLD', 'PRU', 'PEG', 'PSA', 'PHM', 'PVH', 'QEP', 'PWR', 'QCOM', 'DGX', 'RRC', 'RTN', 'RHT', 'REGN', 'RF', 'RSG', 'RAI', 'RHI', 'ROK', 'COL', 'ROP', 'ROST', 'RDC', 'R', 'SWY', 'CRM', 'SNDK', 'SCG', 'SLB', 'SNI', 'STX', 'SEE', 'SRE', 'SHW', 'SIAL', 'SPG', 'SJM', 'SNA', 'SO', 'LUV', 'SWN', 'SE', 'STJ', 'SWK', 'SPLS', 'SBUX', 'HOT', 'STT', 'SRCL', 'SYK', 'STI', 'SYMC', 'SYY', 'TROW', 'TGT', 'TEL', 'TE', 'THC', 'TDC', 'TSO', 'TXN', 'TXT', 'HSY', 'TRV', 'TMO', 'TIF', 'TWX', 'TWC', 'TJX', 'TMK', 'TSS', 'TSCO', 'RIG', 'TRIP', 'FOXA', 'TSN', 'TYC', 'USB', 'UA', 'UNP', 'UNH', 'UPS', 'X', 'UTX', 'UNM', 'URBN', 'VFC', 'VLO', 'VAR', 'VTR', 'VRSN', 'VZ', 'VRTX', 'VIAB', 'V', 'VNO', 'VMC', 'WMT', 'WAG', 'DIS', 'GHC', 'WM', 'WAT', 'WLP', 'WFC', 'WDC', 'WU', 'WY', 'WHR', 'WFM', 'WMB', 'WIN', 'WEC', 'WYN', 'WYNN', 'XEL', 'XRX', 'XLNX', 'XL', 'XYL', 'YHOO', 'YUM', 'ZMH', 

 


stock = ['ZION', 'ZTS']
stock.each do |stock|
      fname = "#{SUBDIR_DATA}/#{stock}.csv"
    

        puts fname
        co_id = co_ids[stock.to_s]
        co_data = DB.execute("SELECT #{C_FIELDS.join(',')} from companies where ticker_symbol = ?", stock)

  File.open(fname, 'r') do |csv|
    csv.readlines[1..-1].map{|r| r.strip.split(',')}.each do |cols|
      insert_sp_stmt.execute(cols, co_id)       
      # For the database in the SQL chapter,  I have truncated the companies_and_stocks
      # table to a smaller sample      
      # cns_stmt.execute(co_data, cols) if cols[DATE_FD_INDEX] > "2014-05"
    end
  end
end


# Create indicies for faster queries
DB.execute "CREATE INDEX company_id_index ON stock_prices(company_id)"
DB.execute "CREATE INDEX date_index ON stock_prices(date)" 
DB.execute "CREATE INDEX name_idx ON companies_and_stocks(name)" 
DB.execute "CREATE INDEX ticker_idx ON companies_and_stocks(ticker_symbol)" 
DB.execute "CREATE INDEX city_idx ON companies_and_stocks(city)" 
DB.execute "CREATE INDEX state_idx ON companies_and_stocks(state)" 
DB.execute "CREATE INDEX sector_idx ON companies_and_stocks(sector)" 
DB.execute "CREATE INDEX date_idx ON companies_and_stocks(date)" 