class ParkSpotsController < ApplicationController
  # users must furst be authenticated in order to
  # access the park spots resource
  before_action :authenticate_user
  before_action :authorize, only: [:update, :destroy]

  def create
    park_spot = ParkSpot.new(park_spot_params)
    if park_spot.save
      render json: {status: 200, msg: 'Park spot was created.', park_spot: park_spot}
    else
      render json: {status: 204, error: park_spot.errors.full_messages}
    end
  end

  def show
    park_spot = ParkSpot.find(params[:id])
    if park_spot
      render json: park_spot
    else
      render json: {status: 204, error: 'Cound not find park spot.'}
    end
  end

  def update
    park_spot = ParkSpot.find(params[:id])
    if park_spot.update(park_spot_params)
      render json: {status: 200, msg: 'Park spot details have been updated.'}
    else
      render json: {status: 204, errors: park_spot.errors.full_messages}
    end
  end

  def destroy
    park_spot = ParkSpot.find(params[:id])
    if park_spot.destroy
      render json: {status: 200, msg: 'Park Spot has been deleted.'}
    else
      render json: {status: 204, msg: 'Could not delete user.'}
    end
  end

  private
  def park_spot_params
    params.require(:park_spot).permit(:name, :user_id,
        :address, :latitude, :longitude, :price_per_hour,
        :size, :description)
  end

  def authorize
    return_unauthorized unless current_user && ParkSpot.find(params[:id]).user_id.to_s == current_user.id.to_s
  end
end
