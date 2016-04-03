require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './config/boot'
require './config/environment'

date = Time.current
start_date = Time.new(2016,01,10)


while (date<=>start_date) > -1
  puts date
  # Check each hall for each meal
  halls = ["International Village", "Stetson West", "Stetson East", "Outtakes"]
  mealz = ["breakfast", "lunch", "dinner"]
  day = date.day.to_s
  month = date.month.to_s
  year = date.year.to_s
  timeURL = "?from[value][date]=#{year}-#{month}-#{day}"

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
    url = "http://www.nudining.com/#{hallURL}#{timeURL}"
    doc = Nokogiri::HTML(open(url))
    mealz.each do |mealy|
      doc.css("##{mealy} .clear-block").each do |capture|
        found = false
        foodName = capture.css("a").last.text
        # Matches are updated with current info
        Food.all.each do |food|
          if foodName == food.name 
            found = true
            food.count = food.count + 1
            food.save
          end
        end
        # New discoveries are added to the database
        if !found
          Food.create(name: foodName, available: true, dining_halls: ["#{hall}"], meals: ["#{mealy}"], count: 1)
        end
      end
    end
  end
  date = date.yesterday
end