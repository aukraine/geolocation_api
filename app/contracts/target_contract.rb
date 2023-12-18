class TargetContract < BaseContract
  params do
    required(:target).filled(:string)
  end

  rule(:target) do
    ip_match = IPAddress.valid?(value)
    url_match = UrlAddressValidator::URL_REGEXP.match?(value)

    key.failure('Invalid IP or URL address format') unless ip_match || url_match
  end
end
