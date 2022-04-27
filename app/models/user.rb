class User < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Creates a vote for the user using the given restaurant and split value
  def vote(restaurant, split)
   self.votes.create(restaurant_id: restaurant.id, will_split: split)
  end

  # Checks if a restaurant has been favorited by the user
  def has_favorited?(restaurant)
    return self.favorites.exists?(restaurant_id: restaurant.id)
  end

  # Creates a favorite for given restaurant. If the favorite exists, it removes it.
  def favorite(restaurant)
    if self.has_favorited?(restaurant)
      self.favorites.find_by(restaurant_id: restaurant.id).destroy
    else
      self.favorites.create(restaurant_id: restaurant.id)
    end
  end
end
