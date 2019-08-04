# frozen_string_literal: true

module ActiveModel
  module Jobs
    # Automatically includes ActiveModel::Jobs into a Rails app
    class Engine < Rails::Engine
      ActiveSupport.on_load :active_record do
        include ActiveModel::Jobs
      end
    end
  end
end
