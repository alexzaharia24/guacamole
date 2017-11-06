class AvailabilitiesController < ApplicationController
  before_action :authenticate_user
  before_action :authorize, only: [:update, :destroy]

  def show
    availability = Availability.find(params[:id])
    if availability
      render json: availability,
          status: 200
    else
      render json: { msg: 'Could not find availability.' },
          staus: 400
    end
  end

  def update
    availability = Availability.find(params[:id])
    if availability.update(availability_params)
      render json: { msg: 'Availability details have been updated.',
          availability: availability },
          status: 200
    else
      render json: { msg: 'Could not find availability.' },
          status: 400
    end
  end

  def destroy
    availability = Availability.find(params[:id])
    if availability.destroy
      render json: availability,
          status: 200
    else
      render json: { msg: 'Could not find availability.'},
          status: 400
    end
  end

  def create
    availability = Availability.new(availability_params)
    if availability.save
      render json: { msg: 'Availability successfully created.',
          availability: availability },
          status: 200
    else
      render json: { error: availability.errors.full_messages },
          status: 400
    end
  end

  private
  def availability_params
    params.require(:availability).permit(:park_spot_id, :date, :start_time,
        :end_time)
  end
  def authorize
    head :unauthorized unless current_user
    user_id = current_user.id
    availability = Availability.find(params[:id])
    head :unauthorized unless current_user.is_admin? || \
        availability.park_spot.user_id.to_s == user_id.to_s
  end
end
