class FieldSerializer < ActiveModel::Serializer
  attributes :id, :name, :code
  belongs_to :event
end
