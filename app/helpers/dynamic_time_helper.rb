module DynamicTimeHelper
  def dynamic_time_tag(time)
    time_tag(time, data: { behavior: "dynamic-time-tag" })
  end
end
