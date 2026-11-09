class NeighborhoodsController < ApplicationController
  before_action :set_neighborhood, only: [:edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize Neighborhood
    @neighborhoods = Neighborhood.order(:name)
  end

  def new
    @neighborhood = Neighborhood.new
    authorize @neighborhood
  end

  def create
    @neighborhood = Neighborhood.new(neighborhood_params)
    authorize @neighborhood
    if @neighborhood.save
      redirect_to neighborhoods_path, notice: "Neighborhood created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
    authorize @neighborhood
  end

  def update
    authorize @neighborhood
    if @neighborhood.update(neighborhood_params)
      redirect_to neighborhoods_path, notice: "Neighborhood updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    authorize @neighborhood
    if @neighborhood.destroy
      redirect_to neighborhoods_path, notice: "Neighborhood deleted."
    else
      redirect_to neighborhoods_path, alert: @neighborhood.errors.full_messages.to_sentence
    end
  end

  private

  def set_neighborhood
    @neighborhood = Neighborhood.find(params[:id])
  end

  def neighborhood_params
    params.require(:neighborhood).permit(:name)
  end
end