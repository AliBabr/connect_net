class Event < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :goings, dependent: :destroy
end
