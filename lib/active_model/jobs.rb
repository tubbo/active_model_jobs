require "active_model"
require "active_model/jobs/version"

module ActiveModel
  # Include this module into your model to take advantage of
  # automatically-generated :#{job_name}! action methods for any
  # matching ActiveJob classes.
  #
  # @api public
  module Jobs
    # @type [RegExp]
    BANG = /!\Z/

    # Call +perform_later+ on an ActiveJob class corresponding to an
    # undefined action method name.
    #
    # @throws NoMethodError if no job matches the action method
    def method_missing(method, *arguments)
      return super unless respond_to? method
      job_for(method).perform_later(self)
    end

    # Test whether the action method exists on this class.
    #
    # @returns [FalseClass] if the method does not end in a '!'
    # @returns [FalseClass] if the method does not correspond to a job
    # @returns [TrueClass] if a job with a corresponding name is found
    def respond_to?(method)
      method_for_job?(method) || super
    end

    private

    def method_for_job?(method)
      return false unless method.to_s =~ BANG
      job_for(method).present?
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
