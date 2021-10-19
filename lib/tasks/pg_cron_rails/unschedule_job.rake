# frozen_string_literal: true

namespace :pg_cron_rails do
  desc "Unschedule a job"
  task :unschedule_job, [:job_name] => :environment do |_t, args|
    ActiveRecord::Base.connection.unschedule_pg_cron_job(args[:job_name])
    puts "The pg_cron job #{args[:job_name]} was successfully unscheduled"
  rescue StandardError => e
    puts "Something went wrong while unscheduling the pg_cron job with name #{args[:job_name]}"
    puts e
  end
end
