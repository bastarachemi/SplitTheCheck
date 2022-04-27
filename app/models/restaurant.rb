class Restaurant < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
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

  # Gets the restaurant's number of will_split votes
  def will_split
    self.votes.where(will_split: true).count
  end

  # Gets the restaurant's number of wont_split votes
  def wont_split
    self.votes.where(will_split: false).count
  end
end
