module Api
  module V1
    class ListingsController < BaseController
      def index
        @listings = Listing.published
                            .includes(property: [:neighborhood, :amenities])
                            .in_neighborhood(params[:neighborhood_id])
                            .max_rent(params[:max_rent])
                            .available_from(params[:available_from])
                            .with_amenity(params[:amenity_id])
                            .order(created_at: :desc)
      end

      def show
        @listing = Listing.published
                           .includes(property: [:neighborhood, :amenities])
                           .find_by(id: params[:id])

        if @listing
          render :show
        else
          render json: { error: "Listing not found" }, status: :not_found
        end
      end
    end
  end
end