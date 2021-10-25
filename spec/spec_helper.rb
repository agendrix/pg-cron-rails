# frozen_string_literal: true

require File.expand_path('../spec/dummy/config/environment.rb', __dir__)
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '../../../spec/dummy'

require 'rspec/rails'
