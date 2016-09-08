class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@" + ENV["MAILGUN_DOMAIN"]
  layout 'mailer'
end
