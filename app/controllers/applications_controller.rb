class ApplicationsController < ApplicationController
  before_action :set_listing, only: [:create, :destroy]
  before_action :set_application, only: [:update]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def create
    @application = @listing.applications.new(application_params)
    @application.seeker = current_user
    authorize @application

    @application.save
    ApplicationsMailer.new_application(@application).deliver_later if @application.persisted?

    render partial: "applications/frame",
           locals: { listing: @listing, application: @application },
           status: @application.persisted? ? :ok : :unprocessable_content
  end

  def destroy
    @application = current_user.applications.find_by!(listing: @listing)
    authorize @application
    @application.withdraw!

    render partial: "applications/frame", locals: { listing: @listing, application: @application }
  end

  def index
    authorize Application
    scope = policy_scope(Application).includes(:seeker, :visit, listing: :property)

    @received = scope.joins(listing: :property)
                      .where(properties: { host_id: current_user.id })
                      .order(created_at: :desc)

    @sent = scope.where(seeker_id: current_user.id).order(created_at: :desc)
    @pending_count = @received.count { |a| a.state == "pending" }
  end

  def update
    authorize @application

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
    @application = policy_scope(Application).find(params[:id])
  end

  def application_params
    params.require(:application).permit(:message, :move_in_date, :duration_months)
  end
end