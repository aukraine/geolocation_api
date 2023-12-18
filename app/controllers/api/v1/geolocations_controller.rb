class API::V1::GeolocationsController < ApplicationController
  before_action :set_resource, only: [:show, :destroy]

  def index
    authorize Geolocation

    render json: policy_scope(Geolocation)
  end

  def show
    authorize resource

    render json: {}
  end

  def create
    authorize Geolocation

    render json: {}
  end

  def destroy
    authorize resource

    render json: {}
  end

  private

  def set_resource = @resource = Geolocation.find(params[:id])
end
