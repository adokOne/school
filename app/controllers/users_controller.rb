class UsersController < ApplicationController

  before_filter :require_login, except: [:signin, :forgot, :registration, :login, :create ]

  before_filter :is_own?, only: [:show,:update,:edit]

  def index
    @users = (1..5).to_a
  end

  def login
    if user = User.where(email: allowed_params[:email]).take
      if user.blocked
        flash[:error] = (t('b1_admin.admin_blocked') + (user.blocked_until ? t('b1_admin.admin_blocked_until') % [user.blocked_until.strftime("%d.%m.%Y %H:%M:%S")] : ""))
        redirect_to login_users_path
      elsif !user.active
        flash[:error] = t('b1_admin.admin_not_active')
        redirect_to login_users_path
      else
        if (token = user.sign_in(allowed_params[:password], request.remote_ip, request.referer, request.user_agent))
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
    user = User.new(allowed_params)
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

  end

  def edit

  end

  def show

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

  def allowed_params
    params.require(:login).permit(:name,:email,:password)
  end

end
