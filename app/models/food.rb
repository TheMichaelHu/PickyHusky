class Food < ActiveRecord::Base
  has_and_belongs_to_many :users

  def self.search(search)
    where("lower(name) LIKE ?", "%#{search.downcase}%")
  end
end
