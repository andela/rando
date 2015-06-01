class TransactionMailer < ApplicationMailer
  default from: 'andela-rando@rando.com'

  def send_email (to, body, subject)
    mail(to: to, subject: subject, body: body, content_type: 'text/html')
  end
end
