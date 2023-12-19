class StoreGeolocation < BaseService
  def initialize(target:, _user:, **)
    @target = target
  end

  def call
    parse_target_attrs
    verify_exists_geolocation if ip
    fetch_geolocation_data
    transform_geolocation_data
    verify_persisted_geolocation if url
    geolocation.present? ? edit_geolocation : store_geolocation
    # send_email - here is good place to do such business logic.

    success(geolocation.reload)
  rescue => e
    Rails.logger.error("[ERROR] [#{e.class.name}] #{e.message}")
    failure(e)
  end

  private

  attr_reader :target, :ip, :url, :geolocation, :geo_data

  def parse_target_attrs
    IPAddress.valid?(target) ? @ip = target : @url = target
  end

  def verify_exists_geolocation
    @geolocation = Geolocation.find_by(ip: ip)
    raise ActiveRecord::RecordNotUnique, 'Geolocation is already exists' if geolocation
  end

  def fetch_geolocation_data
    @geo_data = Ipstack::GetData.new.call(target)
  end

  def transform_geolocation_data
    @geo_data = Ipstack::HandleData.new(geo_data).transform
  end

  def verify_persisted_geolocation
    @geolocation = Geolocation.find_by(ip: geo_data[:ip])
  end

  def edit_geolocation
    geolocation.update!(url: url, **geo_data)
    raise ActiveRecord::RecordNotUnique, 'Geolocation is already exists'
  end

  def store_geolocation
    @geolocation = Geolocation.new(url: url, **geo_data)
    raise Errors::BadRequest.new(*geolocation.errors.to_a) unless geolocation.save
  end
end
