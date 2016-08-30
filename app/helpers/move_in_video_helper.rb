module MoveInVideoHelper
  def link_to_move_in_video(appearance:)
    Helper.new(appearance, self).link_to_move_in_video
  end

  def link_to_move_from_video(appearance:)
    Helper.new(appearance, self).link_to_move_from_video
  end

  class Helper
    pattr_initialize :appearance, :view_context

    def link_to_move_in_video
      view_context.link_to(
        appearance.video_name,
        path,
      )
    end

    def link_to_move_from_video
      view_context.link_to(
        TimeFormatter.new(appearance.minutes, appearance.seconds).format,
        path,
      )
    end

    private

    def path
      view_context.video_path(
        appearance.video,
        autoplay: "true",
        start: move_starting_point,
      )
    end

    def move_starting_point
      appearance.minutes * 60 + appearance.seconds
    end
  end
end
