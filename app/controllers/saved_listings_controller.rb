class SavedListingsController < ApplicationController
  before_action :set_listing, only: [:create, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def create
    @saved_listing = current_user.saved_listings.find_or_initialize_by(listing: @listing)
    authorize @saved_listing
    @saved_listing.save if @saved_listing.new_record?

    render partial: "saved_listings/toggle", locals: { listing: @listing, saved: true }
  end

  def destroy
    @saved_listing = current_user.saved_listings.find_by(listing: @listing) ||
                      current_user.saved_listings.build(listing: @listing)
    authorize @saved_listing
    @saved_listing.destroy if @saved_listing.persisted?

    render partial: "saved_listings/toggle", locals: { listing: @listing, saved: false }
  end

  def index
    authorize SavedListing
    @saved_listings = policy_scope(SavedListing)
                         .includes(listing: { property: :neighborhood })
                         .order(created_at: :desc)
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end
end