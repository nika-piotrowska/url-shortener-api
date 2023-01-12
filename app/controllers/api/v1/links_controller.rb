class Api::V1::LinksController < ApplicationController
  before_action :authenticate

  def show
    @link = Link.find_by(id: params[:id])
    if @link&.belongs_to?(@user)
      render json: { link: @link.serializable_hash.except("user_id") }, status: :ok
    elsif @link.present?
      render json: { message: 'You are unauthorized to perform this action.' }, status: :unauthorized
    else 
      render json: { message: 'Unable to find Link.' }, status: :not_found
    end
  end

  def create
    @link = Link.new(link_params)
    @link.user = @user
    if @link.save
      render json: { id: @link.id, shortened_link: @link.shortened_link }, status: :ok
    else
      render json: { message: @link.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
  def link_params
    params.require(:link).permit(:long_link)
  end
end
