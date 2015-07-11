module ActiveModel
  #
  module Jobs
    # A support class for finding the +ActiveJob::Base+ that corresponds
    # to a given action method on a given model. When the job class is
    # found, the action method fires off a new instance of the job.
    #
    # @api private
    # @private
    class Performer
      # @type [RegExp]
      BANG = /!\Z/

      # @attr_reader
      # @type [String]
      attr_reader :method_name

      # @attr_reader
      # @type [String]
      attr_reader :model_name

      # @param [String] method_name - A method corresponding to a job.
      # @param [String] model_name - The model we are calling this from.
      def initialize(method_name, model_name)
        @method_name = method_name.to_s
        @model_name = model_name.to_s
      end

      # Tests whether this method name corresponds to a job class in the
      # application.
      #
      # @returns [Boolean] whether this job exists or not
      def job?
        method_name =~ BANG && job_class.present?
      end

      # Attempts to find the job class for this method and return it,
      # otherwise it returns +nil+ when encountering a +NameError+.
      #
      # @returns [ActiveJob::Base] a job class or nil
      def job_class
        job_name.classify.constantize
      rescue NameError
        nil
      end

      # Build the conventional job name from the given method and model.
      # Suffix with +job+ and separate with underscores.
      #
      # @returns [String] the underscored job class name
      def job_name
        [
          action_name, model_name, 'job'
        ].join '_'
      end

      # Strip the '!' off of the end of the method.
      #
      # @returns [String]
      def action_name
        method_name.gsub BANG, ''
      end

      # Perform this action on the given model.
      #
      # @param [ActiveModel::Model]
      # @returns [TrueClass]
      def call(model)
        return false unless job?
        job_class.perform_later model
      end
    end
  end
end
