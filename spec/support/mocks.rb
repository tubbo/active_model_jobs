require 'active_support/all'

class RefreshMockerJob
  def self.perform_later(model)
    model.refreshed = true
  end
end

class KickoffMockerJob
  def self.perform_later(model)
    model.created = true
  end
end

class Mocker
  include ActiveModel::Model
  include ActiveModel::Jobs

  attr_accessor :id, :name, :refreshed, :created

  validates :name, presence: true

  define_model_callbacks :save, :create, :update

  after_create :kickoff!
  after_update :refresh!

  def save
    run_callbacks :save do
      return false unless valid?
      return create unless persisted?

      update
    end
  end

  def persisted?
    id.present?
  end

  def created?
    persisted? && created
  end

  def refreshed?
    refreshed || false
  end

  private

  def create
    return true if persisted?

    run_callbacks :create do
      self.id = 1
      true
    end
  end

  def update
    return false unless persisted?

    run_callbacks :update do
      self.id = 2
      true
    end
  end
end
