class User < ApplicationRecord
  has_many :votes, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Creates a vote for the user using the given restaurant and split value
  def vote(restaurant, split)
   self.votes.create(restaurant_id: restaurant.id, will_split: split)
  end
end
