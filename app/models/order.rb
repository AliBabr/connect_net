class Order < ApplicationRecord
  belongs_to :job
  belongs_to :application
  has_many_attached :order_source_files
end
