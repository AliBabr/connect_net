class Job < ApplicationRecord
  belongs_to :user
  has_many_attached :media
  has_many :applications, dependent: :destroy
end
