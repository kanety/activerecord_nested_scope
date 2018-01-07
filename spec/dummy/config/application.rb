require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"

Bundler.require(*Rails.groups)
require "activerecord_nested_scope"

module Dummy
  class Application < Rails::Application
    unless (database = ENV['DATABASE'].to_s).empty?
      config.paths["config/database"] = "config/database_#{database}.yml"
      ENV['SCHEMA'] = Rails.root.join("db/schema_#{database}.rb").to_s
    end
  end
end
