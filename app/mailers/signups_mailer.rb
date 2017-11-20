class SignupsMailer < ApplicationMailer
  default template_path: "mailers/signups"

  def new_signup(id)
    @contact = Contact.find id

    @contact.organization.users.subscribed_to_signup_alerts.each do |user|
      mail to: user.email, subject: "#{@contact.contact.full_name} has signed up on TmT."
    end
  end
end
