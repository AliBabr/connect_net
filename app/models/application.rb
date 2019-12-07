class Application < ApplicationRecord
  belongs_to :job
  has_one :order
  belongs_to :user
end
