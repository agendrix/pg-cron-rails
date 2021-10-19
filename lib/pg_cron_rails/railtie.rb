# frozen_string_literal: true

require "rails/railtie"

module PgCronRails
  class Railtie < ::Rails::Railtie
    railtie_name :pg_cron_rails

    initializer "pg_cron_rails.load" do
      ActiveSupport.on_load :active_record do
        PgCronRails.load
      end
    end

    rake_tasks do
      path = File.expand_path("..", __dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each do |task|
        load task
      end
    end
  end
end
