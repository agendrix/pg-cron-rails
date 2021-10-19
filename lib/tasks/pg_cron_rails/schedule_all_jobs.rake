# frozen_string_literal: true

namespace :pg_cron_rails do
  desc "Schedule all jobs"
  task schedule_all_jobs: :environment do |_t, _args|
    pg_cron_jobs.each do |job_name|
      ActiveRecord::Base.connection.schedule_pg_cron_job(job_name)
    end
    puts "All the pg_cron jobs were successfully scheduled"
  rescue StandardError => e
    puts "Something went wrong while scheduling the pg_cron jobs"
    puts e
  end

  private

  def pg_cron_jobs
    Dir["#{PgCronRails::Configuration::JOBS_DIRECTORY}/*.yml"].map do |file|
      file = file.chomp(".yml")
      file.split("/").last
    end
  end
end
