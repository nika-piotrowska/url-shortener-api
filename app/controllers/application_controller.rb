class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def not_found
    redirect_to ENV['SAFE_REDIRECT_DOMAIN'], allow_other_host: true
  end

  def show_link
    link = Link.find_by(shortened_link: request.url)
    redirect_to link&.long_link || ENV['SAFE_REDIRECT_DOMAIN'], allow_other_host: true
  end

  private

  def authenticate
    user || handle_bad_authentication
  end

  def user
    authenticate_with_http_token do |token, _options|
      @user ||= User.find_by(encrypted_key: token)
    end
  end

  def handle_bad_authentication
    render json: { message: 'Bad credentials' }, status: :unauthorized
  end
end
