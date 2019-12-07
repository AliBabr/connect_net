class Order < ApplicationRecord
  belongs_to :job
  belongs_to :application
end
