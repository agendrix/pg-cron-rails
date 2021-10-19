# frozen_string_literal: true

class PgCronJobGenerator < ::Rails::Generators::NamedBase
  include ::Rails::Generators::Migration
  source_root File.expand_path("templates", __dir__)

  def create_job_file
    template "pg_cron_job.erb", "db/pg_cron_jobs/#{file_name}.yml"
  end

  def job_name
    file_name
  end

  def create_migration_file
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")

    template "pg_cron_job_migration.erb", "db/migrate/#{timestamp}_#{migration_name}.rb"
  end

  def migration_name
    "add_#{file_name}_pg_cron_job"
  end

  def migration_class_name
    migration_name.camelize
  end

  def migration_version
    @migration_version = "[#{::Rails::VERSION::MAJOR}.#{::Rails::VERSION::MINOR}]"
  end
end
