class VideoWithUrlHint < SimpleDelegator
  def url_hint
    if video.errors[:url].present?
      "This link is unsupported, only videos from YouTube and Vimeo are allowed."
    else
      "Videos from YouTube and Vimeo are supported."
    end
  end

  private

  def video
    __getobj__
  end
end
