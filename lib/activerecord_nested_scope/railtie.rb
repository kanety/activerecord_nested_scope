module ActiveRecordNestedScope
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :active_record do
      ActiveRecord::Base.send :include, ActiveRecordNestedScope::Extension
    end
  end
end
