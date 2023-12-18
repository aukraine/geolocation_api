class GeolocationCollection < BaseResource
  attributes :id
  attribute :type, &:kind

  nested_attribute :attributes do
    attributes :ip, :url
  end
end
