class Category < ApplicationRecord
  has_many :roles
  validates :title, presence: true, uniqueness: { case_sensitive: false }

  def self.search(pattern)
    if pattern.blank? # blank? covers both nil and empty string
      all
    else
      where("title LIKE ? OR title LIKE ?", "%#{pattern.upcase}%", "%#{pattern.downcase}%")
    end
  end
end
