# frozen_string_literal: true

module PgCronRails
  class Configuration
    DEFAULT_PG_DATABASE_NAME = "postgres"
    JOBS_DIRECTORY = "db/pg_cron_jobs"

    # The connection configuration to use when executing pg_cron statements.
    # Defaults to the current connection host and user with default PSQL database.
    attr_writer :connection_config
    attr_reader :connection

    def initialize
      set_connection
    end

    def set_connection
      @connection = PgCronRails::Adapters::PostgresqlAdapter.new(
        ActiveRecord::Base.postgresql_connection(@connection_config || default_pg_cron_connection)
      )
    end

    private

    def default_pg_cron_connection
      default_pg_cron_connection = ActiveRecord::Base.connection_db_config.configuration_hash.deep_dup
      default_pg_cron_connection[:database] = DEFAULT_PG_DATABASE_NAME
      
      default_pg_cron_connection
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration

    @configuration.set_connection
  end
end
