# frozen_string_literal: true

namespace :pg_cron_rails do
  desc "Schedule a job"
  task :schedule_job, [:job_name] => :environment do |_t, args|
    ActiveRecord::Base.connection.schedule_pg_cron_job(args[:job_name])
    puts "The pg_cron job #{args[:job_name]} was successfully scheduled"
  rescue StandardError => e
    puts "Something went wrong while scheduling the pg_cron job with name #{args[:job_name]}"
    puts e
  end
end
