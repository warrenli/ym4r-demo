class LocationsController < ApplicationController
  def index
    @locations = Location.all
  end
  
  def show
    @location = Location.find(params[:id])
  end
  
  def new
    @location = Location.new
  end
  
  def create
    @location = Location.new(params[:location])
    if @location.save
      flash[:notice] = "Successfully created location."
      redirect_to @location
    else
      render :action => 'new'
    end
  end
  
  def edit
    @location = Location.find(params[:id])
  end
  
  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Successfully updated location."
      redirect_to @location
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @location = Location.find(params[:id], :include => :city)
    name = @location.name
    @location.destroy
    flash[:notice] = "Record for #{name} successfully destroyed."
    redirect_to city_url(@location.city)
  end
end
