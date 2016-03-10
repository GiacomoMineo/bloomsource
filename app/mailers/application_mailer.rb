class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@hermione.com"
  layout 'mailer'
end
