desc "This task is called by the Heroku scheduler add-on"
task :reset_daily_reviews => :environment do
  puts "Resetting daily reviews..."
  User.reset_daily_reviews

  User.all.each do |user|
	  reviewer_data = { daily_reviews: user.daily_reviews }
	  ReviewsChannel.broadcast_to user, reviewer_data
	  head :ok    	
  end
  puts "done."
end

task :send_reminders => :environment do
  User.send_reminders
end