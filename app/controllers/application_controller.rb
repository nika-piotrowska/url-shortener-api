class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private

  def authenticate
    authenticate_user_with_token || handle_bad_authentication
  end

  # TODO: Make sure method name matches the name of memoized instance variable inside
  # rubocop:disable Naming/MemoizedInstanceVariableName
  def authenticate_user_with_token
    authenticate_with_http_token do |token, _options|
      @user ||= User.find_by(encrypted_key: token)
    end
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def handle_bad_authentication
    render json: { message: 'Bad credentials' }, status: :unauthorized
  end
end
