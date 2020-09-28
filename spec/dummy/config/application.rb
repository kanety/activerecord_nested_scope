require_relative 'boot'

# Pick the frameworks you want:
require "active_record/railtie"
require "active_job/railtie"

Bundler.require(*Rails.groups)
require "activerecord_nested_scope"

module Dummy
  class Application < Rails::Application
    suffix = ""
    if Rails::VERSION::MAJOR >= 6
      suffix += "_rails6"
    end
    if ENV['DATABASE'].present?
      suffix += "_#{ENV['DATABASE']}"
    end

    config.paths["config/database"] = "config/database#{suffix}.yml"
    ENV['SCHEMA'] = Rails.root.join("db/schema#{suffix}.rb").to_s
  end
end
