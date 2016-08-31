class RatingsController < ApplicationController
  before_action :require_login

  def create
    rateable = if params[:move_id]
                 Move.find(params[:move_id])
               else
                 Video.find(params[:video_id])
               end
    rateable.ratings.create!(rating: params.require(:rating), user: current_user)

    render partial: "shared/current_ratings", locals: { rateable: rateable.reload }
  end
end
