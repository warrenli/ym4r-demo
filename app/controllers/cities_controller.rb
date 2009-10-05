class CitiesController < ApplicationController
  def index
    set_whole_map
  end

  def show
    @city = City.find(params[:id])
    @city.locations.build
    set_city_map(@city)
  end

  def create
    @city = City.new(params[:city])
    if @city.save
      flash.now[:notice] = "Record for #{@city.name} successfully created."
    else
      flash.now[:notice] = "City #{params[:city][:name]} not found."
    end
    set_whole_map
    render :action => 'index'
  end

  def update
    @city = City.find(params[:id])
    if @city.update_attributes(params[:city])
      flash[:notice] = "Successfully updated city."
      redirect_to @city
    else
      render :action => 'show'
    end
  end

  def destroy
    @city = City.find(params[:id])
    name = @city.name
    @city.destroy
    flash[:notice] = "Record for #{name} successfully destroyed."
    redirect_to cities_url
  end

  private

  def set_whole_map
    @city = City.new
    @map = GMap.new( "map_div" )
    @map.control_init(:large_map => true, :map_type => true)

    markers = []
    cities = City.all
    cities.each do |city|
      marker = GMarker.new([city.latitude,city.longitude], :title => city.name, :info_window => city_info(city))
      @map.overlay_init(marker)
      markers << marker
    end

    center = bounding_box_center(markers, [10, 80])
    @map.center_zoom_init(center, 2)
  end

  def city_info(city)
     show_link = url_for :action => 'show', :id => city
     token = form_authenticity_token
     info = <<-EOF
    <b>#{city.name}</b>
    <br /><br />
    <a href='#{show_link}'>Tell me more</a>
    <br /><br />
    <form method='post' action="/cities/#{city.id}" class='button-to'>
    <input type='hidden' name='_method' value='delete' />
    <input name='authenticity_token' type='hidden' value='#{token}' />
    <input onclick="return confirm('Are you sure?');" value='Delete' type='submit' />
    </form>
     EOF
     return info
  end

  def bounding_box_center(markers, default_center)
    return default_center if markers.empty?
    maxlat, maxlng, minlat, minlng = -Float::MAX, -Float::MAX, Float::MAX, Float::MAX
    markers.each do |marker|
      coord = marker.point
      maxlat = coord.lat if coord.lat > maxlat
      minlat = coord.lat if coord.lat < minlat
      maxlng = coord.lng if coord.lng > maxlng
      minlng = coord.lng if coord.lng < minlng
    end
    return [(maxlat + minlat)/2,(maxlng + minlng)/2]
  end

  def set_city_map(city)
    @map = GMap.new( "map_div" )
    @map.control_init(:large_map => true, :map_type => true)

    markers = []
    city.locations.each do |location|
      unless location.new_record?
        marker = GMarker.new([location.latitude,location.longitude], :title => location.name,
                :info_window => location_info(location))
        @map.overlay_init(marker)
        markers << marker
      end
    end

    center = city.latlon
    center = bounding_box_center(markers, center)
    @map.center_zoom_init(center, 10)
  end

  def location_info(location)
    token = form_authenticity_token
    info = <<-EOF
    <b>#{location.name}</b>
    <br />
    <b>#{location.street}</b>
    <br /><br />
    <form method='post' action="/locations/#{location.id}">
    <input type='hidden' name='_method' value='delete' />
    <input name='authenticity_token' type='hidden' value='#{token}' />
    <input onclick="return confirm('Are you sure?');" value='Delete' type='submit' />
    </form>
     EOF
     return info
  end
end
