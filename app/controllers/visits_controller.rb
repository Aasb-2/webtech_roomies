class VisitsController < ApplicationController
  before_action :set_application

  def create
    @visit = @application.build_visit(visit_params.merge(status: "scheduled"))
    @visit.save
    redirect_to applications_path, notice: @visit.persisted? ? "Visit proposed." : @visit.errors.full_messages.to_sentence
  end

  def update
    @visit = @application.visit

    success = case params[:status]
    when "confirmed" then @visit.confirm!
    when "cancelled" then @visit.cancel!
    when "completed" then @visit.complete!
    when "scheduled" then @visit.reschedule!(params[:proposed_date])
    else false
    end

    redirect_to applications_path, notice: success ? "Visit updated." : "That change isn't allowed right now."
  end

  private

  def set_application
    @application = Application.find(params[:application_id])
  end

  def visit_params
    params.require(:visit).permit(:proposed_date)
  end
end