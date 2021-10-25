# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pg_cron_rails/version"

Gem::Specification.new do |s|
  s.name          = "pg_cron_rails"
  s.version       = PgCronRails::VERSION
  s.authors       = ["Louis Boudreau"]
  s.email         = ["l.boudreau@agendrix.com"]
  s.license       = "MIT"
  s.required_ruby_version = ">= 2.7.0"

  s.summary       = "pg_cron jobs scheduling for Rails"
  s.description   = "pg_cron jobs scheduling for Rails"
  s.homepage      = "https://github.com/agendrix/pg-cron-rails"

  # sify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|s|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", ">= 6.0.0"
  s.add_dependency "activesupport", ">= 6.0.0"
  s.add_dependency "railties", ">= 6.0.0"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rubocop", "~> 1.7"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'pg'
end
