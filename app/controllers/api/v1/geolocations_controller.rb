class API::V1::GeolocationsController < ApplicationController
  def index
    authorize Geolocation
    collection = policy_scope(Geolocation)
    serialized = GeolocationCollection.new(collection).serialize

    render json: serialized, status: :ok
  end

  def show
    params = validate(TargetContract)
    resource = set_resource(params[:target])
    authorize resource
    serialized = GeolocationResource.new(resource).serialize

    render json: serialized, status: :ok
  end

  def create
    authorize Geolocation
    params = validate(TargetContract)
    resource = handle_service(StoreGeolocation, _user: current_user, **params)

    render json: resource, status: :created
  end

  def destroy
    params = validate(TargetContract)
    resource = set_resource(params[:target])
    authorize resource
    resource.destroy!

    render json: { data: { message: 'Record has been successfully deleted' } }, status: :ok
  end

  private

  def set_resource(target) = Geolocation.find_by_ip_or_url(target).first!
end
