class Restaurant < ApplicationRecord
  has_many :votes, dependent: :destroy
  validates :name, :city, :state, presence: true
  validates :name, uniqueness: {scope: [:city, :state]}

  # Searches for restaurants by name and location
  def self.search(restaurant_name, restaurant_location)
    restaurant = Restaurant.all
    if restaurant_name.present?
      restaurant = restaurant.where('name LIKE ?', "%#{restaurant_name}%")
    end
    if restaurant_location.present?
      location = restaurant_location.split(",")
      location.collect!{ |e| e.strip }
      restaurant = restaurant.where('(city LIKE ? OR state LIKE ?) AND state LIKE ?', "%#{location[0]}%", "%#{location[0]}%", "%#{location[1]}%")
    end
    return restaurant
  end

  # Increases restaurant's number of will_split or wont_split votes
  def vote(split)
    if split == :will_split
      self.increment(:will_split)
    elsif split == :wont_split
      self.increment(:wont_split)
    end
    self.save
  end
end
