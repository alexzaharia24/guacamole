class ParkSpotsController < ApplicationController
  # users must furst be authenticated in order to
  # access the park spots resource
  before_action :authenticate_user
  before_action :authorize, only: [:update, :destroy]

  def create
    park_spot = ParkSpot.new(park_spot_params)
    if park_spot.save
      render json: { msg: 'Park spot was created.', park_spot: park_spot },
          status: 200
    else
      render json: { error: park_spot.errors.full_messages},
          status: 400
    end
  end

  def show
    park_spot = ParkSpot.find(params[:id])
    if park_spot
      render json: park_spot,
          status: 200
    else
      render json: {error: 'Cound not find park spot.'},
          status: 400
    end
  end

  def update
    park_spot = ParkSpot.find(params[:id])
    if park_spot.update(park_spot_params)
      render json: { msg: 'Park spot details have been updated.' },
          status: 200
    else
      render json: { errors: park_spot.errors.full_messages },
          status: 400
    end
  end

  def destroy
    park_spot = ParkSpot.find(params[:id])
    if park_spot.destroy
      render json: { msg: 'Park Spot has been deleted.'},
          status: 200
    else
      render json: { msg: 'Could not delete user.' },
          status: 400
    end
  end

  def park_spots_for_user
    render json: current_user.park_spots
  end

  private
  def park_spot_params
    params.require(:park_spot).permit(:name, :user_id,
        :address, :latitude, :longitude, :price_per_hour,
        :size, :description)
  end

  def authorize
    head :unauthorized unless current_user \
        && (ParkSpot.find(params[:id]).user_id.to_s == current_user.id.to_s \
        || current_user.is_admin?)

  end
end
