# Licensor
class Licensor < ActiveRecord::Base
  enum status: [:active, :closed]

  validates :name, :reseller, presence: true
  validates :name, length: { in: 3..255 }
  validates :status, inclusion: {
    in:      Licensor.statuses.keys,
    message: '%{value} is not a valid status'
  }

  belongs_to :reseller
  has_many :licenses
end
