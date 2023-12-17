class IpAddressValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:ip, 'Invalid IP address format') unless IPAddress.valid?(record.ip)
  end
end
