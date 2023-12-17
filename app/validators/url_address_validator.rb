class UrlAddressValidator < ActiveModel::Validator
  URL_REGEXP = /\A(?:([A-Za-z]+):)?(\/{0,3})(?:www\.)?[a-zA-Z0-9.-]+(?:\.[a-zA-Z]{2,})+(?:\/[^\s]*)?(?::(\d+))?\z/

  def validate(record)
    record.errors.add(:url, 'Invalid URL format') unless record.url.nil? || record.url =~ URL_REGEXP
  end
end
