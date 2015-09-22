module ActiveModel
  #
  module Jobs
    # A support class for finding the +ActiveJob::Base+ that corresponds
    # to a given action method on a given model. When the job class is
    # found, the action method fires off a new instance of the job.
    #
    # @private
    class Performer
      # Regular expression for finding a '!' at the end of a String.
      BANG = /!\Z/

      # The method name given to the class as a String.
      #
      # @attr_reader [String]
      attr_reader :method_name

      # The model name given to the class by +ActiveModel::Naming+.
      #
      # @attr_reader [String]
      # @see http://api.rubyonrails.org/classes/ActiveModel/Naming.html
      attr_reader :model_name

      # @param [String] method_name A method corresponding to a job.
      # @param [String] model_name The model we are calling this from.
      def initialize(method_name, model_name)
        @method_name = method_name.to_s
        @model_name = model_name.to_s
      end

      # Tests whether the given method name ends with a '!'.
      #
      # @return [Boolean]
      def self.action?(method)
        method =~ BANG
      end

      # Tests whether this method name corresponds to a job class in the
      # application.
      #
      # @return [Boolean] whether this job exists or not
      def job?
        method_name =~ BANG && job_class.present?
      end

      # Attempts to find the job class for this method and return it,
      # otherwise it returns +nil+ when encountering a +NameError+.
      #
      # @return [ActiveJob::Base] a job class or nil
      def job_class
        job_name.classify.constantize
      rescue NameError
        nil
      end

      # Build the conventional job name from the given method and model.
      # Suffix with +job+ and separate with underscores.
      #
      # @return [String] the underscored job class name
      def job_name
        "#{action_name}_#{model_name}_job"
      end

      # Strip the '!' off of the end of the method.
      #
      # @return [String] '!'-stripped version of the method name.
      def action_name
        method_name.gsub BANG, ''
      end

      # Perform this action on the given model.
      #
      # @param [ActiveModel::Model] model The model object we are
      # performing the job on
      # @return [TrueClass, FalseClass] whether the job succeeded to
      # enqueue.
      def call(model)
        return false unless job?
        job_class.perform_later model
      end
    end
  end
end
