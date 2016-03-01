class ApplicationMailer < ActionMailer::Base
  default from: "info@speakclub.com.ua"

  def send_mail( template, to_email, vars = {} )
    template = EmailTemplate.find_by_seo_name(template)
    mail_options = {
      to: to_email,
      subject: template.subject
    }
    html = _prepare_template(template.desc.to_s, vars)

    mail(mail_options) do |format|
      format.html {render html: html.html_safe}
    end

  end

  def call_mail( to, name , phone )
    @name = name
    @phone = phone
    mail(:to => to, :subject => "Нове замовлення дзвінка")
  end

  private

  def _prepare_template( template , vars)
    vars.each_pair do |key,text|
      template.to_s.gsub!("%#{key.to_s.upcase}%",text)
    end
    template
  end


end


