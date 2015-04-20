class VideoAppearances
  def initialize(video:, move_names:, minutes:, seconds:)
    @video = video
    @move_names = move_names
    @minutes = minutes
    @seconds = seconds
  end

  def save
    remove_current_appearances!

    appearances = zipped_params.map do |move, minutes, seconds|
      Appearance.new(
        move: move,
        video_id: @video.id,
        minutes: minutes,
        seconds: seconds
      )
    end

    if appearances.all?(&:valid?)
      appearances.map(&:save)
      true
    else
      false
    end
  end

  private

  def zipped_params
    @move_names.map.with_index do |move_name, i|
      [
        Move.find_by_name(move_name),
        @minutes[i],
        @seconds[i],
      ]
    end
  end

  def remove_current_appearances!
    Appearance.where(video: @video).destroy_all
  end
end
