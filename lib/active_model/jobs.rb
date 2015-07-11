require "active_model"
require "active_model/jobs/version"
require "active_model/jobs/performer"

module ActiveModel
  # Include this module into your model to take advantage of
  # automatically-generated :#{job_name}! action methods for any
  # matching ActiveJob classes.
  #
  # @api public
  module Jobs
    # Call +perform_later+ on an ActiveJob class corresponding to an
    # undefined action method name. Most of the work here is done in the
    # +Performer+ class, which takes care of discoevering whether the
    # method passed in corresponds to a given job or whether we should
    # just delegate back to +ActiveRecord::Base+. This method will
    # prevent a new +Perfomer+ class from being instantiated for every
    # method call by using a guard clause to check whether the method is
    # an action method before proceeding on further checks.
    #
    # @throws NoMethodError if no job matches the action method
    def method_missing(method, *arguments)
      return super unless performer = job_performer(method)
      performer.call self
    end

    private

    def job_performer(method)
      return unless method =~ Performer::BANG
      Performer.new method, model_name
    end
  end
end
