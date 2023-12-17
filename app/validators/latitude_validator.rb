class LatitudeValidator < ActiveModel::Validator
  LAT_LIMIT_DEGREES = 180

  def validate(record)
    unless (-LAT_LIMIT_DEGREES..LAT_LIMIT_DEGREES).include?(record.latitude)
      record.errors.add(:latitude, 'must be between -90 and 90')
    end
  end
end
