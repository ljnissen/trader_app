set :output, "C:\Sites\RailsProjects\trader_app - Copy\log\cron.log"

every :day, at: "10:30 AM" do
	rake "all"
end
