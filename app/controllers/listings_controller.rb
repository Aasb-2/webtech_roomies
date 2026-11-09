class ListingsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_property, only: [:new, :create, :edit, :update, :destroy, :publish, :withdraw, :mark_rented]
  before_action :set_listing, only: [:edit, :update, :destroy, :publish, :withdraw, :mark_rented]
  after_action :verify_authorized

  def index
    authorize Listing
    @listings = Listing.published
                        .includes(property: [:neighborhood, :amenities])
                        .in_neighborhood(params[:neighborhood_id])
                        .max_rent(params[:max_rent])
                        .available_from(params[:available_from])
                        .with_amenity(params[:amenity_id])
                        .order(created_at: :desc)

    @neighborhoods = Neighborhood.order(:name)
    @amenities = Amenity.order(:name)
  end

  def show
    @listing = Listing.includes(property: [:neighborhood, :amenities, :reviews]).find(params[:id])
    authorize @listing
    @reviews = @listing.property.reviews.order(created_at: :desc)
    @application = current_user ? (current_user.applications.find_by(listing: @listing) || @listing.applications.build) : nil
  end

  def new
    @listing = @property.listings.new
    authorize @listing
  end

  def create
    @listing = @property.listings.new(listing_params)
    authorize @listing
    if @listing.save
      redirect_to property_path(@property), notice: "Listing created as a draft. Publish it when it's ready."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @listing
  end

  def update
    authorize @listing
    if @listing.update(listing_params)
      redirect_to property_path(@property), notice: "Listing updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @listing
    @listing.destroy
    redirect_to property_path(@property), notice: "Listing deleted."
  end

  def publish
    authorize @listing
    if @listing.publish!
      redirect_to property_path(@property), notice: "Listing published."
    else
      redirect_to property_path(@property), alert: "Only a draft listing can be published."
    end
  end

  def withdraw
    authorize @listing
    if @listing.withdraw!
      redirect_to property_path(@property), notice: "Listing withdrawn."
    else
      redirect_to property_path(@property), alert: "A rented listing can't be withdrawn."
    end
  end

  def mark_rented
    authorize @listing
    if @listing.mark_rented!
      redirect_to property_path(@property), notice: "Listing marked as rented."
    else
      redirect_to property_path(@property), alert: "Only a reserved listing can be marked as rented."
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def set_listing
    @listing = @property.listings.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(
      :monthly_rent, :deposit, :available_date, :minimum_stay,
      :furnished, :private_bathroom, :description, :house_rules,
      photos: []
    )
  end
end