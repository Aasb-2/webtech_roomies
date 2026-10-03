class ListingsController < ApplicationController
  def index
    @listings = Listing.published
                        .includes(:property)
                        .in_neighborhood(params[:neighborhood])
                        .max_rent(params[:max_rent])
                        .available_from(params[:available_from])
                        .with_amenity(params[:amenity])
                        .order(created_at: :desc)

    @neighborhoods = Property.distinct.order(:neighborhood).pluck(:neighborhood)
  end

  def show
    @listing = Listing.includes(property: :reviews).find(params[:id])
    @reviews = @listing.property.reviews.order(created_at: :desc)
  end
end