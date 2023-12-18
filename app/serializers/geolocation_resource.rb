class GeolocationResource < BaseResource
  attributes :id
  attribute :type, &:kind

  nested_attribute :attributes do
    attributes :ip, :url, :type, :latitude, :longitude, :location
  end
end
