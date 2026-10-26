class AmenitiesController < ApplicationController
  before_action :set_amenity, only: [:edit, :update, :destroy]

  def index
    @amenities = Amenity.order(:name)
  end

  def new
    @amenity = Amenity.new
  end

  def create
    @amenity = Amenity.new(amenity_params)
    if @amenity.save
      redirect_to amenities_path, notice: "Amenity created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @amenity.update(amenity_params)
      redirect_to amenities_path, notice: "Amenity updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    if @amenity.destroy
      redirect_to amenities_path, notice: "Amenity deleted."
    else
      redirect_to amenities_path, alert: @amenity.errors.full_messages.to_sentence
    end
  end

  private

  def set_amenity
    @amenity = Amenity.find(params[:id])
  end

  def amenity_params
    params.require(:amenity).permit(:name)
  end
end