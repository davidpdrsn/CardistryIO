module Api
  class VideosController < Api::AdminController
    def approve
      video = Video.find(params[:id])
      video.update!(approved: true)
      head :ok
    end

    def unapproved
      render json: Video.unapproved, root: false
    end

    def destroy
      video = Video.find(params[:id])
      video.destroy!
      head :ok
    end
  end
end
