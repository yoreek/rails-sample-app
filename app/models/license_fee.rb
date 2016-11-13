# License fee
class LicenseFee < ActiveRecord::Base
  validates :amount, :start_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  # validate :start_date_is_valid?

  belongs_to :license

  private

  def start_date_is_valid?
    return if start_date.blank?
    Date.parse(start_date)
  rescue ArgumentError
    errors.add(:start_date, 'must be a valid date')
  end
end
