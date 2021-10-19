# frozen_string_literal: true

module PgCronRails
  module Statements
    def schedule_pg_cron_job(name)
      with_pg_cron_connection do |connection|
        job = parse_pg_cron_job(name)
        connection.schedule_pg_cron_job(job)
      end
    end

    def unschedule_pg_cron_job(name)
      with_pg_cron_connection do |connection|
        job = parse_pg_cron_job(name)
        connection.unschedule_pg_cron_job(job)
      end
    end

    def update_pg_cron_job(name)
      with_pg_cron_connection do |connection|
        job = parse_pg_cron_job(name)
        connection.update_pg_cron_job(job)
      end
    end

    private

    def parse_pg_cron_job(name)
      job = YAML.safe_load(ERB.new(File.read(Rails.root.join("#{PgCronRails::Configuration::JOBS_DIRECTORY}/#{name}.yml"))).result)
      job_name = job.keys.first
      job = job[job_name]
      job = job.symbolize_keys
      job[:name] = job_name
      unless job.key?(:database)
        current_database = ActiveRecord::Base.connection_db_config.configuration_hash[:database]
        job[:database] = current_database
      end

      job
    end

    def with_pg_cron_connection
      yield PgCronRails.connection if PgCronRails.connection.extension_enabled?("pg_cron")
    end
  end
end
