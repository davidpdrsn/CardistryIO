class TimeSlots
  pattr_initialize :objs

  def today
    grouped_objs.fetch(:today, [])
  end

  def yesterday
    grouped_objs.fetch(:yesterday, [])
  end

  def last_week
    grouped_objs.fetch(:last_week, [])
  end

  def older_than_one_week
    grouped_objs.fetch(:older_than_one_week, [])
  end

  private

  def grouped_objs
    @grouped_objs ||= calculate_grouped_objs
  end

  def calculate_grouped_objs
    objs.each_with_object(Hash.new([])) do |obj, acc|
      created_at = obj.created_at.utc.to_date

      if created_at == Date.today
        acc[:today] = acc[:today] + [obj]
      elsif created_at == 1.day.ago.to_date
        acc[:yesterday] = acc[:yesterday] + [obj]
      elsif date_is_within_last_week?(created_at)
        acc[:last_week] = acc[:last_week] + [obj]
      elsif date_is_more_than_one_week_ago?(created_at)
        acc[:older_than_one_week] = acc[:older_than_one_week] + [obj]
      end
    end
  end

  def date_is_more_than_one_week_ago?(date)
    date < 1.week.ago.to_date
  end

  def date_is_within_last_week?(date)
    (1.week.ago.to_date..2.days.ago.to_date).cover?(date)
  end

  def objects_on_date(date)
    objs.select do |obj|
      obj.created_at.to_date == date
    end
  end
end
