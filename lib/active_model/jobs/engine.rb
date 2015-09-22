if defined? Rails
  module ActiveModel
    module Jobs
      # Hooks into the host Rails application that include
      # +ActiveModel::Jobs+ into every model that includes
      # +ActiveModel::Model+.
      class Engine < Rails::Engine
        initializer 'active_model_jobs.setup', before: :load_environment_config do
          ActiveSupport.on_load :active_model do
            ActiveModel::Model.send :include, ActiveModel::Jobs
          end
        end
      end
    end
  end
end
