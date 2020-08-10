namespace :daily_reviews do
  desc "This task resets all users' daily reviews"

  task :reset_daily_reviews do
    puts "\n\n JUST RESET THOSE REVIEWS MY GUY \n\n"
    # User.update_all("daily_reviews = 0")
  end
end