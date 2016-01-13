class EmailNotFoundException < StandardError ; end
class MailManager
  attr_reader :template, :email, :attachments, :from

  def registration( user ,password )
    raise ArgumentError, "Param must be an instance of User" unless user.kind_of?( User )
    check_template( "registration" )
    @email = user.email
    data = {
      :USER_PASWORD => password,
      :USER_LOGIN    => user.email,
      :USER_NAME     => user.name
    }
    set_body( data )
    send_mail( user.email )
  end



  def restore( user ,password )
    raise ArgumentError, "Param must be an instance of User" unless user.kind_of?( User )
    check_template( "restore" )
    @email = user.email
    data = {
      :USER_PASSWORD => password,
      :USER_LOGIN    => user.email,
      :USER_NAME     => user.name
    }
    set_body( data )
    send_mail( user.email )
  end

  def order( user ,product )
    raise ArgumentError, "Param must be an instance of User" unless user.kind_of?( User )
    check_template( "order" )
    @email = user.email
    data = {
      :PRODUCT       => product,
      :USER_EMAIL    => user.email,
      :USER_NAME     => user.name
    }
    set_body( data )
    send_mail( user.email )
  end

  def payment( user , amount )
    raise ArgumentError, "Param must be an instance of User" unless user.kind_of?( User )
    check_template( "payment" )
    @email = user.email
    data = {
      :AMOUNT       => amount,
      :USER_EMAIL    => user.email,
      :USER_NAME     => user.name
    }
    set_body( data )
    send_mail( user.email )
  end


  def accept_review( review )
    raise ArgumentError, "Param must be an instance of User" unless user.kind_of?( User )
    check_template( "review_published" )
    @email = review.email
    data = {
      :NAME         => review.name,
      :TITLE        => review.page.title,
      :URL          => review.page.link,
      :USER_NAME    => review.page.try(:user).try(:name)
    }
    set_body( data )
    send_mail( review.email )


    check_template( "has_review" )
    @email = review.page.try(:user).try(:email).email
    set_body( data )
    send_mail( review.page.try(:user).try(:email) )

  end

  private

  def attach(file)
    @attachments = {} unless @attachments.kind_of? Hash
    @attachments.merge! file
    return self
  end

  def check_template( seo_name  )
    @template = EmailTemplate.active_template( seo_name ).first
    raise EmailNotFoundException, "Active EmailTemplate with seo_name #{seo_name} not found!" unless @template
    @template = @template.dup
    return self
  end

  def set_body( data = {} )
    data = data.merge!( { :EXTRANET_DOMAIN => Settings.domain } )
    data.each_pair do |k,v|
      @template.text.gsub!( "%#{k}%", v.to_s )
    end
    return self
  end

  def send_mail(email)
    @email = email
    Thread.abort_on_exception = true
    # Thread.new do
      ApplicationMailer.send_mail( @template, email, @attachments, @from).deliver_now
    # end
    return self
  end

  class << self
    def method_missing( name, *args )
      if MailManager.method_defined?(name.to_sym)
        begin
          mailer = MailManager.new.send(name,*args)
          AppLogger.success(:application, 18, mailer.template, mailer.email  )
        rescue EmailNotFoundException => e
          AppLogger.error(:application, 18, [e.message,e.backtrace].join("||") )
        end
      else
        super
      end
    end
  end
end
