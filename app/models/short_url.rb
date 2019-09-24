class ShortUrl < ApplicationRecord
  CHARSET = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze

  validates_presence_of :full_url
  validate :validate_full_url

  after_create :generate_short_code

  def short_code
    return nil unless id

    result = []
    value = id
    numeric_base = CHARSET.count

    while value > 0
      remainder = value % numeric_base
      if remainder.zero?
        remainder = CHARSET.count
        value = value / numeric_base - 1
      else
        value /= numeric_base
      end

      result.unshift(CHARSET[remainder])
    end

    result.join
  end

  def update_title!
    UpdateTitleJob.perform_now(id)
  end

  private

  def validate_full_url
    uri = URI.parse(full_url)
    uri.is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    errors.add(:full_url, "is not a valid url")
    false
  end

  def generate_short_code
    update(short_code: short_code)
  end
end
