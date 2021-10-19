# pg_cron Rails
[pg_cron](https://github.com/citusdata/pg_cron) jobs scheduling for Rails applications


## Configuration

By default, no configuration is needed to use this gem. 

PgCronRails schedules your pg_cron jobs in the default PSQL database using your current database connection user.

You can also customize PgCronRails database connection configuration by creating an initializer:
```ruby
PgCronRails.configure do |config|
    config.connection_config =  {
        username: username
        password: password
        database: database
    }
end
```

## Usage

**Create pg_cron job**
1. Generate a job:
```bash
rails generate pg_cron_job daily_vacuum
      create  db/pg_cron_jobs/daily_vacuum.yml
      create  db/migrate/[TIMESTAMP]_add_daily_vacuum_pg_cron_job.rb
```

2. Define `db/pg_cron_jobs/daily_vacuum.yml` job params. 
```yml
daily_vacuum:
    cron: "3 5 * * *"
    statement: "VACUUM VERBOSE ANALYZE"
    database: <%= ActiveRecord::Base.connection.current_database %> # This parameter is optional
```

3. Run the migration

```bash
rails db:migrate
```


## Methods

The methods added to `ActiveRecord::Migration` are defined in [PgCronRails::Statements](https://github.com/agendrix/pg-cron-rails/blob/main/lib/pg_cron_rails/statements.rb)


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
