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

  end

  every(1.day, 'main.job')
  every(10.second, 'main.job')
end