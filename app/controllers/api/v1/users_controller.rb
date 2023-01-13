class Api::V1::UsersController < ApplicationController
  before_action :authenticate, except: [:create]

  def create
    @user = User.new
    if @user.save
      render json: { encrypted_key: @user.encrypted_key}, status: :ok
    else
      render json: { message: 'Unable to create User.' }, status: :bad_request
    end
  end

  def refresh_encrypted_key
    @user.encrypted_key = SecureRandom.uuid
    if @user.save
      render json: { encrypted_key: @user.encrypted_key, message: 'This is your new key.'  }, status: :ok
    else
      render json: { message: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
