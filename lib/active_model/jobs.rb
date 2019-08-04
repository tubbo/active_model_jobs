require "active_support/all"
require "active_model"
require "active_model/jobs/version"
require "active_model/jobs/performer"
require "active_model/jobs/engine" if defined? Rails

# :nodoc:
module ActiveModel
  # Include this module into your model to take advantage of
  # automatically-generated +:job_name!+ action methods for any
  # matching ActiveJob classes.
  #
  # @example
  #   class MyModel < ActiveRecord::Base
  #     include ActiveModel::Jobs
  #
  #     after_commit :deploy!
  #   end
  module Jobs
    # Method suffix for actions.
    ACTION_SUFFIX = '!'

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
      performer = Performer.new method, model_name
      return super unless respond_to?(method) && performer.job?
      performer.call self
    end

    # Allow the model to respond to all "action" methods (methods
    # suffixed by +!+)
    def respond_to_missing?(method, include_private = true)
      method.to_s.end_with?(ACTION_SUFFIX) || super
    end
  end
end
