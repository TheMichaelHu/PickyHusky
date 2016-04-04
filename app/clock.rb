require 'clockwork'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    
    # Reset the database
    Food.all.each do |food|
      food.available = false
      food.meals = []
      food.dining_halls = []
      food.save
    end

    # Check each hall for each meal
    halls = ["International Village", "Stetson West", "Stetson East", "Outtakes"]
    mealz = ["breakfast", "lunch", "dinner"]

    halls.each do |hall|
      # Find the appropriate URL addition
      hallURL = ''
      case hall 
      when 'International Village'
        hallURL = 'international-village'
      when 'Stetson West'
        hallURL = 'stetson-west-eatery'
      when 'Stetson East'
        hallURL = 'levine-marketplace'
      when 'Outtakes'
        hallURL = 'outtakes'
      end

      # Scape the website
      url = "http://www.nudining.com/#{hallURL}"
      doc = Nokogiri::HTML(open(url))
      mealz.each do |mealy|
        doc.css("##{mealy} .clear-block").each do |capture|
          found = false
          foodName = capture.css("a").last.text
          # Matches are updated with current info
          Food.all.each do |food|
            if foodName == food.name 
              found = true
              food.available = true
              if !food.meals.include? "#{mealy}"
                food.meals = food.meals + ["#{mealy}"]
              end
              if !food.dining_halls.include? "#{hall}"
                food.dining_halls = food.dining_halls + ["#{hall}"]
              end
              food.save
            end
          end
          # New discoveries are added to the database
          if !found
            Food.create(name: foodName, available: true, dining_halls: ["#{hall}"], meals: ["#{mealy}"])
          end
        end
      end
    end

    User.each do |user|
      account_sid = 'AC82d2b9fe40b28afaac752136441b10a7' 
      auth_token = '56d81ca61c2e2a6c8531b42cc0cdd7ee' 
       
      @client = Twilio::REST::Client.new account_sid, auth_token 
      msg = ""
      user_foods = user.foods.where(available: true).order("count").limit(10)
      user_foods.each do |food|
        dining_halls = food.dining_halls.inject { |str, dh| str + ", #{dh}" }
        meals = food.meals.inject { |str, meal| str + ", #{meal}" }
        msg += "#{food.name} is available at #{dining_halls} for #{meals}.\n"
      end
      unless user.phone_number.nil? or msg.empty?
        @client.account.messages.create({
          :from => '+16572346969', 
          :to => user.phone_number, 
          :body => msg,  
        })
      end
    end

  end

  every(1.day, 'main.job', :at => '06:00')
end