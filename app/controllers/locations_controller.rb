class LocationsController < ApplicationController
  def destroy
    @location = Location.find(params[:id], :include => :city)
    name = @location.name
    @location.destroy
    flash[:notice] = "Record for #{name} successfully destroyed."
    redirect_to city_url(@location.city)
  end
end
