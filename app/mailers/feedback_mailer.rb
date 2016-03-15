class FeedbackMailer < ApplicationMailer
	default :to => "getbloomsource@gmail.com"
	def send_feedback(feedback)
		@feedback = feedback
		mail from: @feedback.email, subject: @feedback.subject, body: @feedback.content
	end
end
