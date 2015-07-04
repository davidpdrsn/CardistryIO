class AllVideos
  include Enumerable

  def each(&block)
    Video.all_public.each(&block)
  end

  def present?
    Video.all_public.present?
  end

  private
end
