class API::V1::GeolocationsController < ApplicationController
  def index
    authorize Geolocation

    render json: policy_scope(Geolocation)
  end

  def show
    params = validate(TargetContract)
    resource = set_resource(params[:target])
    authorize resource

    render json: params
  end

  def create
    authorize Geolocation
    params = validate(TargetContract)

    render json: params
  end

  def destroy
    params = validate(TargetContract)
    resource = set_resource(params[:target])
    authorize resource

    render json: resource
  end

  private

  def set_resource(target) = Geolocation.find_by_ip_or_url(target).first!
end
