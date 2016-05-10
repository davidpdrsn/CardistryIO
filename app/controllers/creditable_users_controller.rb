class CreditableUsersController < ApplicationController
  before_action :require_login, only: [:index]

  def index
    users = CompositeRelation.new([
      users_matching_search_query,
      creditable_users,
    ])

    respond_to do |format|
      format.json {
        render json: users, each_serializer: UserSerializer, root: false
      }
    end
  end

  private

  def users_matching_search_query
    Searcher::Users.new(params.require(:query)).find_results
  end

  def creditable_users
    CreditableUsers
      .new(current_user: current_user, creditable: creditable)
      .find_users
  end

  def creditable
    if params.key?(:move_id)
      Move.find(params.require(:move_id))
    elsif params.key?(:video_id)
      Video.find(params.require(:video_id))
    else
      NullVideo.new
    end
  end
end
