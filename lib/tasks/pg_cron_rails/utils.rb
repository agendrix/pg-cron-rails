# rubocop:disable Style/SpecialGlobalVars

DEFAULT_PG_CRON_VERSION = "1.3.0".freeze

def validate_homebrew_is_installed
  `brew --version`
  raise "This rake task only support Darwin based OS" unless $?.success?
end

def validate_psql_is_running_with_brew
  fetch_psql_brew_service_version.present?
end

def fetch_psql_brew_service_version
  psql_services = `brew services list | grep "started" | grep "postgresql"`
  psql_services.split(" ").first.strip
end

def validate_rails_environment
  raise "This rake task should only be used in development" unless Rails.env.development?
end

# rubocop:disable Style/GuardClause
# rubocop:disable Layout/LineLength
def validate_latest_psql_is_installed
  `brew list postgresql`
  unless $?.success?
    raise "Due to pg_cron compilation issues the postgresql brew package is needed, please install the latest psql brew package: brew install postgresql"
  end
end
# rubocop:enable Style/GuardClause
# rubocop:enable Layout/LineLength

def pg_cron_is_installed(requested_version)
  result = PgCronRails.connection.execute <<-SQL
    SELECT
      extversion
    FROM
      pg_extension
    WHERE
    extname='pg_cron'
  SQL

  extension_version = result.first&.dig("extversion")
  parsed_extension_version = extension_version ? parse_pg_cron_version(extension_version) : nil
  parsed_requested_version = parse_pg_cron_version(requested_version)
  parsed_extension_version == parsed_requested_version
end

def parse_pg_cron_version(version)
  major_minor_tuple = version.split(".").first(2)
  { major: major_minor_tuple[0], minor: major_minor_tuple[1] }
end

# rubocop:disable Layout/LineLength
def install_pg_cron
  latest_pg_cron_path = `brew --prefix postgresql`.strip
  compilation_path = "#{latest_pg_cron_path}/bin:$PATH"
  pg_cron_version = DEFAULT_PG_CRON_VERSION
  `cd /tmp && \
    curl -s -L https://github.com/citusdata/pg_cron/archive/refs/tags/v#{pg_cron_version}.zip --output pg_cron.zip && \
    unzip -u pg_cron.zip && \
    cd pg_cron-#{pg_cron_version} && \
    PATH=#{compilation_path} make && PATH=#{compilation_path} sudo make install && \
    cp $(brew --prefix postgresql)/share/postgresql/extension/pg_cron* $(brew --prefix #{fetch_psql_brew_service_version})/share/#{fetch_psql_brew_service_version}/extension/ && \
    rm -rf pg_cron*
  `
end
# rubocop:enable Layout/LineLength

def add_pg_cron_to_shared_preload_libraries
  psql_config_file_path = PgCronRails.connection.execute("SHOW config_file").first&.dig("config_file")
  config_file_content = ""
  File.open(psql_config_file_path, "r") do |file|
    file.each_line do |line|
      if line.match(/(#\s*)?shared_preload_libraries =.*/)
        libraries = line.split("=").last.match(/'.*'/).to_a.first.gsub("'", "").split(",").map(&:strip).filter do |s|
          s != "pg_cron"
        end
        libraries << "pg_cron"
        line = "shared_preload_libraries = '#{libraries.join(",")}' \n"
      end

      config_file_content << line
    end
  end

  File.atomic_write(psql_config_file_path, "/tmp") { |file| file.write config_file_content }
end

def remove_pg_cron_from_shared_preload_libraries
  psql_config_file_path = PgCronRails.connection.execute("SHOW config_file").first&.dig("config_file")
  config_file_content = ""
  File.open(psql_config_file_path, "r") do |file|
    file.each_line do |line|
      if line.match(/(#\s*)?shared_preload_libraries =.*/)
        libraries = line.split("=").last.match(/'.*'/).to_a.first.gsub("'", "").split(",").map(&:strip).filter do |s|
          s != "pg_cron"
        end
        line = "shared_preload_libraries = '#{libraries.join(",")}' \n"
        line.prepend("#") if libraries.empty?
      end

      config_file_content << line
    end
  end

  File.atomic_write(psql_config_file_path, "/tmp") { |file| file.write config_file_content }
end

def create_extension
  PgCronRails.connection.enable_extension("pg_cron")
end

def restart_psql_service
  `brew services restart #{fetch_psql_brew_service_version}`
  sleep 1 # Prevent timing issues
end

def drop_extension
  PgCronRails.connection.disable_extension("pg_cron")
end

# rubocop:enable Style/SpecialGlobalVars
