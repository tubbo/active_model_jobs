require 'spec_helper'

module ActiveModel
  module Jobs
    RSpec.describe Performer do
      let :model_name do
        'mocker'
      end

      let :method_name do
        :refresh!
      end

      subject do
        Performer.new method_name, model_name
      end

      let :model do
        Mocker.new name: 'test'
      end

      it 'sets up state with a method name and model name' do
        expect(subject.method_name).to eq(method_name.to_s)
        expect(subject.model_name).to eq(model_name.to_s)
      end

      it 'finds the job' do
        expect(subject).to be_job
      end

      it 'instantiates a job class' do
        expect(subject.job_class).to eq(RefreshMockerJob)
      end

      it 'computes the job name' do
        expect(subject.job_name).to eq('refresh_mocker_job')
      end

      it 'computes the action from the method name' do
        expect(subject.action_name).to eq('refresh')
      end

      it 'performs the action on the job' do
        expect(subject.call(model)).to eq(true)
      end

      context 'when the job class cannot be found' do
        let :method_name do
          :update!
        end

        let :model_name do
          'track'
        end

        it 'cannot find the job' do
          expect(subject).not_to be_job
        end

        it 'returns nil instead of the job class' do
          expect(subject.job_class).to be_nil
        end

        it 'returns false when attempting to call' do
          expect(subject.call(model)).to eq(false)
        end
      end
    end
  end
end
