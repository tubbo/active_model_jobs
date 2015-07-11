require "active_model"
require "active_model/jobs/version"

module ActiveModel
  module Jobs
    BANG = /!\Z/

    def method_missing(method, *arguments)
      return super unless respond_to? method
      job_for(method).perform_later(self)
    end

    def respond_to?(method)
      is_job?(method) || super
    end

    private

    def is_job?(method)
      return false unless method.to_s =~ BANG
      !!job_for(method)
    end

    def job_for(method)
      job_name(method).classify.constantize
    rescue LoadError
      logger.debug "#{job_name(method)} is not defined"
      nil
    end

    def job_name(method)
      [
        job_action_name(method.to_s),
        model_name,
        'job'
      ].join '_'
    end

    def job_action_name(method)
      method.gsub(BANG, '')
    end
  end
end
