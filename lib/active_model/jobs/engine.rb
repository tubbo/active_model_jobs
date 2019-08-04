module ActiveModel
  module Jobs
    class Engine < Rails::Engine
      ActiveSupport.on_load :active_record do
        include ActiveModel::Jobs
      end
    end
  end
end
