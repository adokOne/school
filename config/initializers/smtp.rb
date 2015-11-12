ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :port      => 587,
  :address   => "smtp.mandrillapp.com",
  :user_name        => "administrator@example.ua",
  :password         => 'qwqwqq',
  # :port      => 25,
  # :address   => "smtp.tickets.ua",
}
