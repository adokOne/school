class ApplicationMailer < ActionMailer::Base
  default from: "info@example.ua"

  def send_mail( template, to_email, attachments, from_email )
    mail_options = {
      to: to_email,
      subject: template.subject
    }
    mail_options.merge!(from: from_email) if from_email.present?

    attachments.each{ |k,v| self.attachments[k] = v } if attachments.kind_of? Hash
    mail(mail_options) do |format|
      format.html {render html: template.text.html_safe}
    end
  end
end


