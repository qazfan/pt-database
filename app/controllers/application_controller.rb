require 'net/https'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :banned?
  before_action :convo

  RECAPTCHA_MINIMUM_SCORE = 0.5

  def default_url_options(options={})
    { protocol: "https" }
  end

  def banned?
    if current_user.present? && current_user.banned?
      sign_out current_user
      flash[:error] = "This account has been banned for violating site rules."
      root_path
    end
  end

  def recaptcha_valid?(token)
    return true if Rails.env.development?
    secret_key = Rails.application.credentials.dig(:recaptcha_secret_key)
    uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?secret=#{secret_key}&response=#{token}")
    response = Net::HTTP.get_response(uri)
    json = JSON.parse(response.body)
    json['success'] && json['score'] > RECAPTCHA_MINIMUM_SCORE && json['action'] == recaptcha_action
  end

  def convo
    @unread = 0
    @users = User
    @conversations = Conversation.all.order("created_at DESC")
    if user_signed_in?
      @conversations.each do |conversation|
        if conversation.sender_id == current_user.id || conversation.recipient_id == current_user.id
          if conversation.messages.last
            if conversation.messages.last.read == false && conversation.messages.last.user_id != current_user.id
              @unread += 1
            end
          end
        end
      end
    end
  end

  def authenticate_admin!
    raise unless current_user.admin?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :neoname, :description, :email, :password, :password_confirmation, :remember_me, :terms, :age) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:username, :neoname, :description, :email, :password, :password_confirmation, :current_password)}
  end
end
