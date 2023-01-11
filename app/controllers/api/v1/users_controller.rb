class Api::V1::UsersController < ApplicationController

  def create
    @user = User.new
    if @user.save
      render json: { api_key: @user.encrypted_key}, status: :ok
    else
      render json: { message: 'Unable to create User.' }, status: :bad_request
    end
  end
end
