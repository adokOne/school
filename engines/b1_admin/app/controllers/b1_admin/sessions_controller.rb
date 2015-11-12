module B1Admin
  class SessionsController < ApplicationController
    layout false
    skip_before_action :require_login
    skip_before_action :check_access
    skip_before_filter :verify_authenticity_token , only: :create

    ##
    # Redirect to dashboard if current user is logged else show login form
    # GET /login
    ##
    def new
      if current_admin
        redirect_to(root_url)
      else
        @login = B1Admin::Login.new
        render file: "layouts/b1_admin/login"
      end
    end

    def restore
      response = { success: false }
      admin    = B1Admin::User.where(email: params[:email]).take
      if admin.nil?
        response[:msg] = t('b1_admin.admin_not_found')
      else
        new_password = B1Admin::User.password
        admin.update_attribute(:password, new_password)
        MailManager.password_restore(admin, new_password)
        response = { success: true, msg: t('b1_admin.password_restored') }
      end
      render json: response
    end

    ##
    # Authorize user by login params
    # params:
    #   login: [Hash]
    #     email - User email address [String]
    #     password - User password [String]
    #     remember_me - Flag that indicate remember user authorization by IP and User Agent  [Boolean]
    # POST /login
    # render: JSON
    # Example: {"success": true} | {"success": false, "msg": "User is blocked"}
    ##
    def create
      response = {success:false}
      login = B1Admin::Login.new(params[:login])
      if login.valid? && (admin = B1Admin::User.where(email: login.email).take)
        if admin.blocked
          response[:msg] = (t('b1_admin.admin_blocked') + (admin.blocked_until ? t('b1_admin.admin_blocked_until') % [admin.blocked_until.strftime("%d.%m.%Y %H:%M:%S")] : ""))
        elsif !admin.active
          response[:msg] = t('b1_admin.admin_not_active')
        else
          if (token = admin.sign_in(login.password, request.remote_ip, request.referer, request.user_agent))
            cookies[B1Admin::User::COOKIE_NAME] = { value: token, expires: login.remember_me ? 4.hour.from_now : 2.week.from_now }
            response[:success] = true
          else
            if (attempts_left = (::B1Config.get_const.max_password_attempts - admin.wrong_password_attempts)) > 0
              response[:msg] = t('b1_admin.wrong_password') + (t('b1_admin.attempts_left') % [attempts_left])
            else
              response[:msg] = t('b1_admin.wrong_password') + (t('b1_admin.admin_blocked') + (admin.blocked_until ? t('b1_admin.admin_blocked_until') % [admin.blocked_until.strftime("%d.%m.%Y %H:%M:%S")] : ""))
            end
          end
        end
      else
        response[:msg] = t('b1_admin.wrong_credentials') 
      end
      render json: response
    end

    ##
    # Logout current user and redirect to login form
    # GET /logut
    ##
    def destroy
      if current_admin
        current_admin.signout(cookies[B1Admin::User::COOKIE_NAME], request.remote_ip, request.user_agent)
        cookies.delete(B1Admin::User::COOKIE_NAME)
      end
      redirect_to login_url
    end
  end
end
