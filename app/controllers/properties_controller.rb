class PropertiesController < ApplicationController
  def show
    @property = Property.includes(:listings, :reviews).find(params[:id])
    @published_listings = @property.listings.published
    @reviews = @property.reviews.order(created_at: :desc)
  end
end