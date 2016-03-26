class Test::AttemptsController < ApplicationController

  helper 'test/surveys'

  before_filter :load_active_survey
  before_filter :normalize_attempts_data, :only => :create

  def current_user
    if session[:user_id].present? && User.count(id: session[:user_id])
      User.find(session[:user_id])
    else
      user = User.create
      session[:user_id] = user.id
      user
    end

  end
  def new
    @participant = current_user # you have to decide what to do here

    unless @survey.nil?
      @attempt = @survey.attempts.new
      @attempt.answers.build
    end
  end

  def create
    @attempt = @survey.attempts.new(attempt_params)
    @attempt.participant = current_user

    if @attempt.valid? && @attempt.save
      flash[:alert] = I18n.t("school.test_completed", count: @attempt.correct_answers.count)
      ApplicationMailer.send_mail(Settings.email_templates['test_results'], params[:email], {:EMAIL => params[:email], :USERNAME => params[:name], :PHONE => params[:phone], :TEST_RESULT_COUNT => @attempt.correct_answers.count  }  ).deliver_later
      ApplicationMailer.send_mail(Settings.email_templates['test_results_admin'], Settings.notification_mail, {:EMAIL => params[:email], :USERNAME => params[:name], :PHONE => params[:phone], :TEST_RESULT_COUNT => @attempt.correct_answers.count  }  ).deliver_later

      redirect_to view_context.new_attempt
    else
      render :action => :new
    end
  end

  private

  def load_active_survey
    @survey =  Survey::Survey.active.first
  end

  def normalize_attempts_data
    normalize_data!(params[:survey_attempt][:answers_attributes])
  end

  def normalize_data!(hash)
    multiple_answers = []
    last_key = hash.keys.last.to_i

    hash.keys.each do |k|
      if hash[k]['option_id'].is_a?(Array)
        if hash[k]['option_id'].size == 1
          hash[k]['option_id'] = hash[k]['option_id'][0]
          next
        else
          multiple_answers <<  k if hash[k]['option_id'].size > 1
        end
      end
    end

    multiple_answers.each do |k|
      hash[k]['option_id'][1..-1].each do |o|
        last_key += 1
        hash[last_key.to_s] = hash[k].merge('option_id' => o)
      end
      hash[k]['option_id'] = hash[k]['option_id'].first
    end
  end

  def attempt_params
    rails4? ? params_whitelist : params[:survey_attempt]
  end

  def params_whitelist
    params.require(:survey_attempt).permit(Survey::Attempt::AccessibleAttributes)
  end
end
