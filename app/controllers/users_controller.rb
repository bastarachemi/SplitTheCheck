class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = current_user
    @votes = @user.votes.order('created_at DESC')
    @favorites = @user.favorites.order('created_at DESC')
    @comments = @user.comments.order('created_at DESC')
  end
end
