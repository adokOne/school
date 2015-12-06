class UsersController < ApplicationController

  before_filter :require_login, except: [:signin, :forgot, :registration, :login, :create, :create_message ]

  before_filter :is_own?, only: [:update,:edit]

  def index
    @users = User.active.by_rating.paginate(page: params[:page], per_page: 5)
  end

  def login
    if user = User.where(email: login_params[:email]).take
      if user.blocked
        flash[:error] = (t('b1_admin.admin_blocked') + (user.blocked_until ? t('b1_admin.admin_blocked_until') % [user.blocked_until.strftime("%d.%m.%Y %H:%M:%S")] : ""))
        redirect_to login_users_path
      elsif !user.active
        flash[:error] = t('b1_admin.admin_not_active')
        redirect_to login_users_path
      else
        if (token = user.sign_in(login_params[:password], request.remote_ip, request.referer, request.user_agent))
          cookies[User::COOKIE_NAME] = { value: token, expires: false ? 4.hour.from_now : 2.week.from_now }
          redirect_to user_path(user)
        else
          if (attempts_left = (::B1Config.get_const.max_password_attempts - user.wrong_password_attempts)) > 0
            flash[:error] = t('b1_admin.wrong_password') + (t('b1_admin.attempts_left') % [attempts_left])
            redirect_to login_users_path
          else
           flash[:error] = t('b1_admin.wrong_password') + (t('b1_admin.admin_blocked') + (user.blocked_until ? t('b1_admin.admin_blocked_until') % [user.blocked_until.strftime("%d.%m.%Y %H:%M:%S")] : ""))
           redirect_to login_users_path
          end
        end
      end
    else
      flash[:error] = t('b1_admin.wrong_credentials')
      redirect_to login_users_path
    end
  end

  def create
    user = User.new(login_params)
    if user.valid?
      user.save
      token = user.signin( request.remote_ip, request.referer, request.user_agent)
      cookies[User::COOKIE_NAME] = { value: token, expires: false ? 4.hour.from_now : 2.week.from_now }
      redirect_to user_path(user)
    else
      flash[:errors] = user.errors.messages
      redirect_to registration_users_path
    end
  end

  def update
    params_to_update = allowed_params.dup
    contacts = params_to_update.delete(:contacts_attributes)


    current_user.update_attributes(params_to_update)
    if current_user.valid?
      User.transaction do
        current_user.contacts.map(&:destroy)
        current_user.contacts.create(contacts.values)
      end
      redirect_to edit_user_path(current_user)
    else
      flash[:errors] = current_user.errors.messages
      redirect_to edit_user_path(current_user)
    end

  end

  def edit

  end

  def messages
    @user = User.find(params[:reciver_id])
    @message = Message.new
  end

  def create_message
    message = Message.new(message_params)
    if message.valid?
      if message_to_reply = current_user.received_messages.find_by_id( message.message_id )
        message_to_reply.reply("RE: #{message_to_reply.topic}", message.body)
      else
        current_user.send_message(message.reciver, message.topic, message.body)
      end

      redirect_to user_messages_user_path(current_user, message.reciver)
    else
      flash[:errors] = message.errors.messages
      redirect_to user_messages_user_path(current_user, message.reciver,anchor: "respond")
    end
  end

  def show
    @user = User.find(params[:id])
  end


  def signin
    redirect_to  user_path(current_user) and return if current_user
    @login = Login.new
  end

  def forgot
    redirect_to  user_path(current_user) and return if current_user
    @login = Login.new
  end

  def registration
    redirect_to  user_path(current_user) and return if current_user
    @login = Login.new
  end

  private

  def is_own?
    unless current_user.id == params[:id].to_i
      redirect_to root_path
    end
  end

  def login_params
    params.require(:login).permit(:name,:email,:password)
  end

  def message_params
    params.require(:message).permit(:topic,:body,:reciver_id,:message_id)
  end

  def allowed_params
    params.require(:user).permit(:name,:desc,:avatar, contacts_attributes: [:contact_type,:value])
  end

end
