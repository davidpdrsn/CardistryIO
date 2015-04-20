class TimeFormatter
  def initialize(minutes, seconds)
    @minutes = minutes.to_s
    @seconds = seconds.to_s
  end

  def format
    "#{@minutes.rjust(2, "0")}:#{@seconds.rjust(2, "0")}"
  end
end
