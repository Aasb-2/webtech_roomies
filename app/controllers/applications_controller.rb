class ApplicationsController < ApplicationController
  before_action :set_listing, only: [:create, :destroy]
  before_action :set_application, only: [:update]

  def create
    @application = @listing.applications.new(application_params)
    @application.seeker = current_user
    @application.save

    render partial: "applications/frame",
           locals: { listing: @listing, application: @application },
           status: @application.persisted? ? :ok : :unprocessable_content
  end

  def destroy
    @application = @listing.applications.find_by!(seeker: current_user)
    @application.withdraw!

    render partial: "applications/frame", locals: { listing: @listing, application: @application }
  end

  def index
    @received = Application.joins(listing: :property)
                            .where(properties: { host_id: current_user.id })
                            .includes(:seeker, :visit, listing: :property)
                            .order(created_at: :desc)

    @sent = current_user.applications.includes(:visit, listing: :property).order(created_at: :desc)
    @pending_count = @received.count { |a| a.state == "pending" }
  end

  def update
    previously_contested =
      if params[:state] == "accepted"
        @application.listing.applications.where.not(id: @application.id).where(state: %w[pending shortlisted]).to_a
      else
        []
      end

    success = case params[:state]
    when "shortlisted" then @application.shortlist!
    when "rejected" then @application.reject!
    when "accepted" then @application.accept!
    else false
    end

    @listing = @application.listing
    @auto_rejected = (success && params[:state] == "accepted") ? previously_contested.map(&:reload) : []
    @pending_count = Application.joins(listing: :property)
                                 .where(properties: { host_id: current_user.id }, state: "pending")
                                 .count

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to applications_path, notice: success ? "Application updated." : "That change isn't allowed right now." }
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def set_application
    @application = Application.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:message, :move_in_date, :duration_months)
  end
end