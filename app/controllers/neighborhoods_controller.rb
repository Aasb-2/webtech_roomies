class NeighborhoodsController < ApplicationController
  before_action :set_neighborhood, only: [:edit, :update, :destroy]

  def index
    @neighborhoods = Neighborhood.order(:name)
  end

  def new
    @neighborhood = Neighborhood.new
  end

  def create
    @neighborhood = Neighborhood.new(neighborhood_params)
    if @neighborhood.save
      redirect_to neighborhoods_path, notice: "Neighborhood created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @neighborhood.update(neighborhood_params)
      redirect_to neighborhoods_path, notice: "Neighborhood updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
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