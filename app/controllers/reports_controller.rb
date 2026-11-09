class ReportsController < ApplicationController
  before_action :set_listing, only: [:create]
  before_action :set_report, only: [:update]
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: [:index]

  def create
    @report = @listing.reports.new(report_params)
    @report.reporter = current_user
    authorize @report

    if @report.save
      redirect_to listing_path(@listing), notice: "Thanks, we've received your report."
    else
      redirect_to listing_path(@listing), alert: @report.errors.full_messages.to_sentence
    end
  end

  def index
    authorize Report
    @reports = policy_scope(Report).includes(:reporter, listing: :property).order(created_at: :desc)
  end

  def update
    authorize @report
    if @report.update(status: params[:status])
      redirect_to reports_path, notice: "Report updated."
    else
      redirect_to reports_path, alert: "That change isn't allowed right now."
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:reason, :details)
  end
end