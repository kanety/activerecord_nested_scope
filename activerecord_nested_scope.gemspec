# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord_nested_scope/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord_nested_scope"
  spec.version       = ActiveRecordNestedScope::VERSION
  spec.authors       = ["Yoshikazu Kaneta"]
  spec.email         = ["kaneta@sitebridge.co.jp"]
  spec.summary       = %q{An ActiveRecord extension to build nested scopes}
  spec.description   = %q{An ActiveRecord extension to build nested scopes through pre-defined associations}
  spec.homepage      = "https://github.com/kanety/activerecord_nested_scope"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.0"
  spec.add_dependency "activesupport", ">= 5.0"
  spec.add_dependency "active_record_union"

  spec.add_development_dependency "rails", ">= 5.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry-rails"
  spec.add_development_dependency "pry-byebug"
end
