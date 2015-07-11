require 'spec_helper'

describe ActiveModel::Jobs do
  subject do
    Model.new name: 'name'
  end

  it 'has a version number' do
    expect(ActiveModel::Jobs::VERSION).not_to be nil
  end

  it 'can be included into a model' do
    expect(subject).to be_a(ActiveModel::Jobs)
  end

  it 'kicks off the model after create' do
    expect(subject.save).to eq(true)
    expect(subject).to be_created
    expect(subject).not_to be_refreshed
  end

  it 'refreshes the model after save' do
    subject.id = 1
    subject.created = true

    expect(subject).to be_persisted
    expect(subject.save).to eq(true)
    expect(subject.id).to eq(2)
    expect(subject).to be_refreshed
    expect(subject).to be_created
  end

  it 'refreshes the model on demand' do
    expect(subject.refresh!).to eq(true)
  end
end
