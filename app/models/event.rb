class Event < ApplicationRecord
	belongs_to :source
	has_many :fields#, dependent: :destroy
	has_many :campaigns#, dependent: :destroy
end
