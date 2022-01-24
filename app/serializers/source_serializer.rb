class SourceSerializer < ActiveModel::Serializer
  attributes :id, :name, :code
  has_many :events
end
