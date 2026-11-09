class PropertiesController < ApplicationController
  allow_unauthenticated_access only: %i[ show ]

  before_action :set_property, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize Property
    @properties = current_user.properties.order(created_at: :desc)
  end

  def show
    authorize @property
    @published_listings = @property.listings.published
    @host_listings = @property.listings.order(created_at: :desc) if @property.host_id == current_user&.id
    @reviews = @property.reviews.order(created_at: :desc)
    @review = Review.new
    @can_review = current_user.present? && current_user.id != @property.host_id &&
                  Visit.joins(application: :listing)
                       .where(status: "completed")
                       .where(applications: { seeker_id: current_user.id })
                       .where(listings: { property_id: @property.id })
                       .exists? &&
                  !Review.exists?(property_id: @property.id, seeker_id: current_user.id)
  end

  def new
    @property = current_user.properties.new
    authorize @property
  end

  def create
    @property = current_user.properties.new(property_params)
    authorize @property
    if @property.save
      redirect_to @property, notice: "Property created. Add a listing to start renting out a room."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @property
  end

  def update
    authorize @property
    if @property.update(property_params)
      redirect_to @property, notice: "Property updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @property
    @property.destroy
    redirect_to properties_path, notice: "Property deleted."
  end

  private

  def set_property
    @property = Property.includes(:listings, :reviews, :neighborhood, :amenities).find(params[:id])
  end

  def property_params
    params.require(:property).permit(:address, :neighborhood_id, :property_type, :bedrooms, :bathrooms, :shared_spaces, amenity_ids: [])
  end
end