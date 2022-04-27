class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: %i[ index show go_to_page ]
  before_action :set_restaurant, only: %i[ show edit update destroy ]
  before_action :get_search_values, only: [:index]
  before_action :set_page, only: [:index]
  before_action :get_last_page, only: [:index]
  add_flash_types :success

  # GET /restaurants or /restaurants.json
  def index
    @page = session[:page].to_i
    @last_page = session[:last_page].to_i
    @restaurant_name = session[:restaurant_name]
    @restaurant_location = session[:restaurant_location]
    @restaurants = Restaurant.order('name').search(session[:restaurant_name], session[:restaurant_location]).limit(10).offset((@page - 1) * 10);
    if @restaurants.empty?
      flash.now[:alert] = "No restaurants were found using that search criteria."
    end
  end

  # GET /restaurants/1 or /restaurants/1.json
  def show
    @comments = @restaurant.comments.order('created_at DESC').limit(2);
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants or /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        format.html { redirect_to restaurant_url(@restaurant), notice: "Restaurant was successfully created." }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1 or /restaurants/1.json
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to restaurant_url(@restaurant), notice: "Restaurant was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1 or /restaurants/1.json
  def destroy
    @restaurant.destroy

    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: "Restaurant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Sets the session page using parameter value and redirects to restaurants page
  def go_to_page
    session[:page] = params[:page].to_i.clamp(1, session[:last_page])
    redirect_to restaurants_url
  end

  # Calls the current user's method for upvoting and redirects to current restaurant page
  def upvote
    @restaurant = Restaurant.find(params[:id])
    current_user.vote(@restaurant, true)
    redirect_to restaurant_url(@restaurant), success: "Restaurant was upvoted."
  end

  # Calls the current user's method for downvoting and redirects to current restaurant page
  def downvote
    @restaurant = Restaurant.find(params[:id])
    current_user.vote(@restaurant, false)
    redirect_to restaurant_url(@restaurant), success: "Restaurant was downvoted."
  end

  # Calls the current user's favorite method and redirects to the current restaurant page
  def favorite
    @restaurant = Restaurant.find(params[:id])
    current_user.favorite(@restaurant)
    redirect_to restaurant_url(@restaurant)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :city, :state, :will_split, :wont_split, :restaurant_name, :restaurant_location)
    end

    # Sets the restaurant name and location for the session using the search parameters
    def get_search_values
      if params[:restaurant_name] || params[:restaurant_location]
        session[:page] = 1
        session[:restaurant_name] = params[:restaurant_name]
        session[:restaurant_location] = params[:restaurant_location]
      end
    end

    # Sets the page for the session
    def set_page
      session[:page] ||= 1
    end

    # Sets the last page for the session
    def get_last_page
      session[:last_page] = (1.0 * Restaurant.search(session[:restaurant_name], session[:restaurant_location]).count / 10).ceil()
    end
end
