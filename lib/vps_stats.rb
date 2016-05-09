class VpsStats
  def percentage_of_memory_in_use
    `free | grep Mem | awk '{print $3/$2 * 100.0}'`.to_f
  end

  def percentage_of_disk_space_in_use
    `df -h /`.split("\n").last.split(" ")[-2].sub("%", "").to_f
  end
end
