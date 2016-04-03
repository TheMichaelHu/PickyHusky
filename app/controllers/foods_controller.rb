class FoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @foods = (Food.where("count > 10").where("count < 200").limit(250).shuffle + current_user.foods).uniq
    @user_foods = current_user.foods.map(&:name)
  end

  def submit
    user = current_user
    user.foods = Food.where(name: params.keys)
    user.save!
    flash[:notice] = 'Settings saved!'
    redirect_to root_url
  end

  def search
    @foods = Food.all.map(&:name)
    @user_foods = current_user.foods.map(&:name)
    if params[:search]
      @foods = Food.search(params[:search]).order("count").map(&:name)
    else
      @foods = Food.all.order("name").map(&:name)
    end
  end
end
