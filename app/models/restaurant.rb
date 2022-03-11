class Restaurant < ApplicationRecord
  validates :name, :city, :state, presence: true
  validates :name, uniqueness: {scope: [:city, :state]}

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

  def vote(split)
    if split == :will_split
      self.increment(:will_split)
    elsif split == :wont_split
      self.increment(:wont_split)
    end
    self.save
  end
end
