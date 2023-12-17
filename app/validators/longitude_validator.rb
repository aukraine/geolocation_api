class LongitudeValidator < ActiveModel::Validator
  LONG_LIMIT_DEGREES = 180

  def validate(record)
    unless (-LONG_LIMIT_DEGREES..LONG_LIMIT_DEGREES).include?(record.longitude)
      record.errors.add(:longitude, 'must be between -180 and 180')
    end
  end
end
