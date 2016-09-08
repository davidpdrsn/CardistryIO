class VideoWithUrlHint < SimpleDelegator
  def url_hint
    if video.errors[:url].present?
      "is unsupported, only videos from #{supported_services} are supported"
    else
      "Videos from #{supported_services} are supported"
    end
  end

  private

  def supported_services
    "Instagram, YouTube, and Vimeo"
  end

  def video
    __getobj__
  end
end
