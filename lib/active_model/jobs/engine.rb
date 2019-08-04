module ActiveModel
  module Jobs
    # Automatically includes ActiveModel::Jobs into a Rails app
    class Engine < Rails::Engine
      initialier 'active_model_jobs.mixin' do
        ActiveSupport.on_load :active_record do
          include ActiveModel::Jobs
        end
      end
    end
  end
end
