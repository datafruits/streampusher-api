class Listen < ActiveRecord::Base
  belongs_to :radio

  geocoded_by :ip_address,
      :latitude => :lat, :longitude => :lon
  after_validation :geocode

  def length
    end_at - start_at
  end
end
