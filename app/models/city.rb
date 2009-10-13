class City < ActiveRecord::Base
  has_many :locations, :dependent => :destroy
  attr_accessible :name

  validates_uniqueness_of :name, :case_sensitive => false
  validates_presence_of :name

  accepts_nested_attributes_for :locations
  attr_accessible :locations_attributes

  def latlon
    [self.latitude, self.longitude]
  end

  before_save :set_latlon

  private

  def set_latlon
    results = Geocoding::get(self.name)
    if results.status == Geocoding::GEO_SUCCESS
      self.latitude, self.longitude = results[0].latlon
    else
      errors.add_to_base("City Not Found")
      false
    end
  end

end
