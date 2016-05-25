ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    authentication: :plain,
    user_name: 'gandriero@gmail.com',
    password: 'sisi100502',
    enable_starttls_auto: true,
    domain: 'speakclub.com.ua',
    from: 'info@speakclub.com.ua',
}
