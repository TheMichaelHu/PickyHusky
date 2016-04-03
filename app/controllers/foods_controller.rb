class FoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @foods = Food.all
    @user_foods = current_user.foods.map(&:name)
  end

  def submit
    user = current_user
    user.foods = Food.where(name: params.keys)
    user.save!
    flash[:notice] = 'Settings saved!'
    redirect_to controller: :foods, action: :index
  end
end
