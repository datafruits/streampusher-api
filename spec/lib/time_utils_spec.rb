require_relative '../../lib/time_utils'
require 'spec_helper'

describe TimeUtils do
  it "gets the week of the month for the date" do
    expect(TimeUtils.week_of_month_for_date(Time.local(2017,1,31))).to eq 5
    expect(TimeUtils.week_of_month_for_date(Time.local(2017,4,14))).to eq 2
    expect(TimeUtils.week_of_month_for_date(Time.local(2017,5,27))).to eq 4
  end
end
