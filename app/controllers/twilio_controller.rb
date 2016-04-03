# require 'twilio-ruby'

class TwilioController < ApplicationController  
  # before_action :authenticate_user!

  def send_sms
    account_sid = 'AC82d2b9fe40b28afaac752136441b10a7' 
    auth_token = '56d81ca61c2e2a6c8531b42cc0cdd7ee' 
     
    @client = Twilio::REST::Client.new account_sid, auth_token 
    user = current_user
    msg = ""
    flash_msg = "Something went wrong!"
    user_foods = user.foods.where(available: true).limit(10)
    user_foods.each do |food|
      dining_halls = food.dining_halls.inject { |str, dh| str + ", #{dh}" }
      meals = food.meals.inject { |str, meal| str + ", #{meal}" }
      msg += "#{food.name} is available at #{dining_halls} for #{meals}.\n"
    end
    puts msg
    unless user.phone_number.nil? or msg.empty?
      @client.account.messages.create({
        :from => '+16572346969', 
        :to => user.phone_number, 
        :body => msg,  
      })
      flash_msg = "Check your phone!"
    end
    flash[:notice] = flash_msg
    redirect_to root_url
  end
end