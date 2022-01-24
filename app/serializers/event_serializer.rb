class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :code
  belongs_to :source
  has_many :fields
  has_many :campaigns
end
