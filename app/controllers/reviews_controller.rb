class ReviewsController < ApplicationController
  before_action :set_property

  def create
    @review = @property.reviews.new(review_params)
    @review.seeker = current_user

    if @review.save
      redirect_to @property, notice: "Thanks for your review!"
    else
      redirect_to @property, alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end