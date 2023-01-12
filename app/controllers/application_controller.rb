class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

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
