# frozen_string_literal: true

require "delegate"

module PgCronRails
  module Adapters
    class PostgresqlAdapter < SimpleDelegator
      def schedule_pg_cron_job(job)
        transaction do
          execute <<-SQL
            SELECT
              cron.schedule(
                '#{job[:name]}',
                '#{job[:cron]}',
                #{dollar_quote(job[:statement])}
              )
          SQL

          execute <<-SQL
            UPDATE
              cron.job
            SET
              database = '#{job[:database]}'
            WHERE
              jobname = '#{job[:name]}'
          SQL
        end
      end

      def unschedule_pg_cron_job(job)
        execute <<-SQL
          SELECT cron.unschedule('#{job[:name]}');
        SQL
      end

      # rubocop:disable Style/GuardClause
      def update_pg_cron_job(job)
        transaction do
          query_result = execute <<-SQL
            SELECT
              *
            FROM
              cron.job
            WHERE
             jobname = '#{job[:name]}'
          SQL
          job_exists = query_result.first.present?

          if job_exists
            schedule_pg_cron_job(job)
          else
            raise PG::InternalError, "ERROR: could not find valid entry for job #{quote(job[:name])}"
          end
        end
      end
      # rubocop:enable Style/GuardClause

      private

      # https://www.postgresql.org/docs/13/sql-syntax-lexical.html#SQL-SYNTAX-DOLLAR-QUOTING
      def dollar_quote(statement)
        "$$#{statement}$$"
      end
    end
  end
end
