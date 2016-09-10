class UsersController
  class VideosController < ApplicationController
    def index
      user = User.find(params[:user_id])
      @filter_submit_path = user_videos_path(user)
      @paged_videos = filter_sort_and_paginate(user.videos.approved)
      title t("titles.users.videos.index")

      render "videos/index"
    end

    private

    def filter_sort_and_paginate(videos)
      ListTransformer.new(
        relation: videos,
        params: params,
        filter_with: FiltersVideos,
        sort_with: SortsVideos,
      ).transform
    end
  end
end
