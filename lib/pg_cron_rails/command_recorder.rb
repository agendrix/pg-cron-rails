# frozen_string_literal: true

module PgCronRails
  module CommandRecorder
    def schedule_pg_cron_job(*args)
      record(:schedule_pg_cron_job, args)
    end

    def unschedule_pg_cron_job(*args)
      record(:unschedule_pg_cron_job, args)
    end

    def update_pg_cron_job(*args)
      record(:update_pg_cron_job, args)
    end

    def invert_schedule_pg_cron_job(*args)
      [:unschedule_pg_cron_job, *args]
    end

    def invert_unschedule_pg_cron_job(*args)
      [:schedule_pg_cron_job, *args]
    end
  end
end
