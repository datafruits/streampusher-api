class Listen < ActiveRecord::Base
  belongs_to :radio

  # geocoded_by :ip_address,
  #     :latitude => :lat, :longitude => :lon
  #
  # reverse_geocoded_by :lat, :lon do |obj, results|
  #   if geo = results.first
  #     obj.address = geo.address
  #     obj.country = geo.country
  #   end
  # end
  # after_validation :geocode
  # after_validation :reverse_geocode

  def length
    self.end_at - self.start_at
  end
end
