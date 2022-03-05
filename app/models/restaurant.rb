class Restaurant < ApplicationRecord
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
end
