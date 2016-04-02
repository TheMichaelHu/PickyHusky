require 'twilio-ruby' 

class TwilioController < ApplicationController  
  # put your own credentials here 
  account_sid = 'AC82d2b9fe40b28afaac752136441b10a7' 
  auth_token = '56d81ca61c2e2a6c8531b42cc0cdd7ee' 
   
  # set up a client to talk to the Twilio REST API 
  @client = Twilio::REST::Client.new account_sid, auth_token 

  def send(phone_number, msg)
    @client.account.messages.create({
      :from => '+16572346969', 
      :to => phone_number, 
      :body => msg,  
    })
  end
end