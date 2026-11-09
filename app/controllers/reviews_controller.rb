class ReviewsController < ApplicationController
  before_action :set_property
  after_action :verify_authorized

  def create
    @review = @property.reviews.new(review_params)
    @review.seeker = current_user
    authorize @review

    if @review.save
      redirect_to @property, notice: "Thanks for your review!"
    else
      redirect_to @property, alert: @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    @review = @property.reviews.find(params[:id])
    authorize @review
    @review.destroy
    redirect_to @property, notice: "Review deleted."
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end