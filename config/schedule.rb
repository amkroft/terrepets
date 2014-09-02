# Use this file to easily define all of your cron jobs.

every 1.day, :at => '1:00 am' do
  # daily maintenance here
  runner "Pet.pet_shelter_pets"
end

# every :reboot do
#   rake 'db:seed'
# end

# every :friday, :at => '4am' do
#   command "rm -rf #{RAILS_ROOT}/tmp/cache"
#   runner "Cart.remove_abandoned"
# end