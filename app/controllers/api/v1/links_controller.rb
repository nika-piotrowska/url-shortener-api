class Api::V1::LinksController < ApplicationController
  before_action :authenticate

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
