# STEP 2/3
#
# PRE: This reads from an existing file called sp500-data.sqlite
# which should have a `companies` table
#
# POST: This downloads .csv files for every company in `companies`

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'

# 'ABT', 'ABBV', 'ACE', 'ACN', 'ACT', 'ADBE', 'ADT', 'AES', 'AET', 'AFL', 'A', 'GAS', 'APD', 'ARG', 'AKAM', 'AA', 'ALXN', 'ATI', 'ALLE', 'AGN', 'ADS', 'ALL', 'ALTR', 'MO', 'AMZN', 'AEE', 'AEP', 'AXP', 'AIG', 'AMT', 'AMP', 'ABC', 'AME', 'AMGN', 'APH', 'APC', 'ADI', 'AON', 'APA', 'AIV', 'AAPL', 'AMAT', 'ADM', 'AIZ', 'T', 'ADSK', 'ADP', 'AN', 'AZO', 'AVGO', 'AVB', 'AVY', 'BHI', 'BLL', 'BAC', 'BK', 'BCR', 'BAX', 'BBT', 'BDX', 'BBBY', 'BMS', 'BRK-B', 'BBY', 'BIIB', 'BLK', 'HRB', 'BA', 'BWA', 'BXP', 'BSX', 'BMY', 'BRCM', 'BF-B', 'CHRW', 'CA', 'CVC', 'COG', 'CAM', 'CPB', 'COF', 'CAH', 'CFN', 'KMX', 'CCL', 'CAT', 'CBG', 'CBS', 'CELG', 'CNP', 'CTL', 'CERN', 'CF', 'SCHW', 'CHK', 'CVX', 'CMG', 'CB', 'CI', 'CINF', 'CTAS', 'CSCO', 'C', 'CTXS', 'CLX', 'CME', 'CMS', 'COH', 'KO', 'CCE', 'CTSH', 'CL', 'CMCSA', 'CMA', 'CSC', 'CAG', 'COP', 'CNX', 'ED', 'STZ', 'GLW', 'COST', 'COV', 'CCI', 'CSX', 'CMI', 'CVS', 'DHI', 'DHR', 'DRI', 'DVA', 'DE', 'DLPH', 'DAL', 'DNR', 'XRAY', 'DVN', 'DO', 'DTV', 'DFS', 'DISCA', 'DG', 'DLTR', 'D', 'DOV', 'DOW', 'DPS', 'DTE', 'DD', 'DUK', 'DNB', 'ETFC', 'EMN', 'ETN', 'EBAY', 'ECL', 'EIX', 'EW', 'EA', 'EMC', 'EMR', 'ESV', 'ETR', 'EOG', 'EQT', 'EFX', 'EQR', 'ESS', 'EL', 'EXC', 'EXPE', 'EXPD', 'ESRX', 'XOM', 'FFIV', 'FB', 'FDO', 'FAST', 'FDX', 'FIS', 'FITB', 'FSLR', 'FE', 'FISV', 'FLIR', 'FLS', 'FLR', 'FMC', 'FTI', 'F', 'FOSL', 'BEN', 'FCX', 'FTR', 'GME', 'GCI', 'GRMN', 'GD', 'GE', 'GGP', 'GIS', 'GM', 'GPC', 'GNW', 'GILD', 'GS', 'GT', 'GOOG', 'GOOGL', 'GWW', 'HAL', 'HOG', 'HAR', 'HRS', 'HIG', 'HAS', 'HCP', 'HCN', 'HP', 'HES', 'HPQ', 'HD', 'HON', 'HRL', 'HSP', 'HST', 'HCBK', 'HUM', 'HBAN', 'ITW', 'IR', 'TEG', 'INTC', 'ICE', 'IBM', 'IGT', 'IP', 'IPG', 'IFF', 'INTU', 'ISRG', 'IVZ', 'IRM', 'JBL', 'JEC', 'JNJ', 'JCI', 'JOY', 'JPM', 'JNPR', 'KSU', 'K', 'KEY', 'GMCR', 'KMB', 'KIM', 'KMI', 'KLAC', 'KSS', 'KRFT', 'KR', 'LB', 'LLL', 'LH', 'LRCX', 'LM', 'LEG', 'LEN', 'LUK', 'LLY', 'LNC', 'LLTC', 'LMT', 'L', 'LO', 'LOW', 'LYB', 'MTB', 'MAC', 'M', 'MMM', 'MRO', 'MPC', 'MAR', 'MMC', 'MAS', 'MA', 'MAT', 'MKC', 'MCD', 'MHFI', 'MCK', 'MJN', 'MWW', 'MDT', 'MRK', 'MET', 'MCHP', 'MU', 'MSFT', 'MHK', 'TAP', 'MDLZ', 'MON', 'MNST', 'MCO', 'MS', 'MOS', 'MSI', 'MUR', 'MYL', 'NBR', 'NDAQ', 'NOV', 'NAVI', 'NTAP', 'NFLX', 'NWL', 'NFX', 'NEM', 'NWSA', 'NEE', 'NLSN', 'NKE', 'NI', 'NE', 'NBL', 'JWN', 'NSC', 'NTRS', 'NOC', 'NU', 'NRG', 'NUE', 'NVDA', 'KORS', 'ORLY', 'OXY', 'OMC', 'OKE', 'ORCL', 'OI', 'PCG', 'PCAR', 'PLL', 'PH', 'PDCO', 'PAYX', 'BTU', 'PNR', 'PNR', 'PBCT', 'POM', 'PEP', 'PKI', 'PRGO', 'PETM', 'PFE', 'PM', 'PSX', 'PNW', 'PXD', 'PBI', 'PCL', 'PNC', 'RL', 'PPG', 'PPL', 'PX', 'PCP', 'PCLN', 'PFG', 'PG', 'PGR', 'PLD', 'PRU', 'PEG', 'PSA', 'PHM', 'PVH', 'QEP', 'PWR', 'QCOM', 'DGX', 'RRC', 'RTN', 'RHT', 'REGN', 'RF', 'RSG', 'RAI', 'RHI', 'ROK', 'COL', 'ROP', 'ROST', 'RDC', 'R', 'SWY', 'CRM', 'SNDK', 'SCG', 'SLB', 'SNI', 'STX', 'SEE', 'SRE', 'SHW', 'SIAL', 'SPG', 'SJM', 'SNA', 'SO', 'LUV', 'SWN', 'SE', 'STJ', 'SWK', 'SPLS', 'SBUX', 'HOT', 'STT', 'SRCL', 'SYK', 'STI', 'SYMC', 'SYY', 'TROW', 'TGT', 'TEL', 'TE', 'THC', 'TDC', 'TSO', 'TXN', 'TXT', 'HSY', 'TRV', 'TMO', 'TIF', 'TWX', 'TWC', 'TJX', 'TMK', 'TSS', 'TSCO', 'RIG', 'TRIP', 'FOXA', 'TSN', 'TYC', 'USB', 'UA', 'UNP', 'UNH', 'UPS', 'X', 'UTX', 'UNM', 'URBN', 'VFC', 'VLO', 'VAR', 'VTR', 'VRSN', 'VZ', 'VRTX', 'VIAB', 'V', 'VNO', 'VMC', 'WMT', 'WAG', 'DIS', 'GHC', 'WM', 'WAT', 'WLP', 'WFC', 'WDC', 'WU', 'WY', 'WHR', 'WFM', 'WMB', 'WIN', 'WEC', 'WYN', 'WYNN', 'XEL', 'XRX', 'XLNX', 'XL', 'XYL', 'YHOO', 'YUM', 'ZMH',

START_DATE=[01, 01, 2014]
END_DATE=[Date.today]
stock = ['ZION', 'ZTS']
stock.each do |stock|
	YURL="http://ichart.finance.yahoo.com/table.csv?s=#{stock}&a=#{START_DATE[0]}&b=#{START_DATE[1]}&c=#{START_DATE[2]}&d=#{END_DATE[0]}&e=#{END_DATE[1]}&f=#{END_DATE[2]}&g=d&ignore=.csv"


DBNAME = "data-hold/sp500-data.sqlite"
DB = SQLite3::Database.new( DBNAME )


SUBDIR = 'data-hold/yahoo-data'
Dir.mkdir(SUBDIR) unless File.exists?SUBDIR

DB.execute("SELECT DISTINCT ticker_symbol from companies").each do |sym|
  fname = "#{SUBDIR}/#{stock}.csv"
  unless File.exists?fname
    puts fname
    d = open("#{YURL}")
    File.open(fname, 'w') do |ofile|
      ofile.write(d.read)
      sleep(1.5 + rand)
    end
  end  
end
end