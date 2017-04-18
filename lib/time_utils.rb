class TimeUtils
  def self.week_of_month_for_date date
    case date.day
    when 1..7
      1
    when 8..14
      2
    when 15..21
      3
    when 22..29
      4
    when 29..31
      5
    end
  end
end
