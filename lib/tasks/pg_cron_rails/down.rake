# frozen_string_literal: true

require_relative "utils"

namespace :pg_cron_rails do
  desc "Tear down pg_cron PSQL extension for your development environment"
  task :down, [:pg_cron_version] => :environment do |_t, args|
    puts "Tearing down pg_cron"
    validate_rails_environment
    validate_homebrew_is_installed
    validate_psql_is_running_with_brew
    if pg_cron_is_installed(args[:pg_cron_version] || DEFAULT_PG_CRON_VERSION)
      drop_extension
      remove_pg_cron_from_shared_preload_libraries
      restart_psql_service
    end
  rescue StandardError => e
    puts "Something went wrong while tearing down pg_cron"
    puts e
  end
end
