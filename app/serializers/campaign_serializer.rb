class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :state, :conditions
  belongs_to :event
end
