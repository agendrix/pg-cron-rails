# frozen_string_literal: true

require_relative "utils"

namespace :pg_cron_rails do
  desc "Install and enable pg_cron PSQL extension for your development environment"
  task :up, [:pg_cron_version] => :environment do |_t, args|
    puts "Setting up pg_cron"
    validate_rails_environment
    validate_homebrew_is_installed
    validate_latest_psql_is_installed
    validate_psql_is_running_with_brew
    if !pg_cron_is_installed(args[:pg_cron_version] || DEFAULT_PG_CRON_VERSION)
      install_pg_cron
      add_pg_cron_to_shared_preload_libraries
      restart_psql_service
      create_extension
    else
      restart_psql_service
    end
  rescue StandardError => e
    puts "Something went wrong while setting up pg_cron"
    puts e
  end
end
