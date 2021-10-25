require "spec_helper"

module PgCronRails
  RSpec.describe 'Statements' do
    it "must not fail if pg_cron extension is not enabled" do
      expect { ActiveRecord::Base.connection.schedule_pg_cron_job("dummy_job") }.to_not raise_error
    end
  end
end
