class ApplicationMailer < ActionMailer::Base
  default from: 'no-replay@aptexx-hydra.herokuapp.com'
  layout 'mailer'
end
