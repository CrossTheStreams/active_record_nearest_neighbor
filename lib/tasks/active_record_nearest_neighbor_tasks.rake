desc "Explaining what the task does"
namespace :active_record_nearest_neighbor do
  task :setup => :environment do
    Rails.logger.info("hey there!")
  end
end

