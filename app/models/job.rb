class Job < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_one :order, dependent: :destroy
  has_one :feedback, dependent: :destroy
  has_many :applications, dependent: :destroy
end
