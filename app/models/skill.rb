class Skill < ApplicationRecord
  has_and_belongs_to_many :users

  def self.search(pattern)
    if pattern.blank? # blank? covers both nil and empty string
      all
    else
      where("text LIKE ?", "%#{pattern}%")
    end
  end
end
