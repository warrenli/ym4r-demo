class Location < ActiveRecord::Base
  belongs_to :city
  attr_accessible :city_id, :name, :street

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :city_id, :name, :street

  def address
    self.city.name << " " << self.street
  end

  def latlon
    [self.latitude, self.longitude]
  end

  before_save :set_latlon

  private

  def set_latlon
    results = Geocoding::get( address )
    if results.status == Geocoding::GEO_SUCCESS
      self.latitude, self.longitude = results[0].latlon
    else
      errors.add_to_base("Location Not Found")
      false
    end
  end
end
