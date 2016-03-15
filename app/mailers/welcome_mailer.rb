class WelcomeMailer < ApplicationMailer

	def welcome_email(user)
    	@user = user
    	mail(to: @user.email, subject: 'Welcome to Bloomsource, do you have any feedback?')    	
  	end
end
