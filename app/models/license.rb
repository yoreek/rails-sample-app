# License
class License < ActiveRecord::Base
  enum licensing_type: [:monthly, :revenue_share]
  enum status: [:active, :closed]

  validates :name, :licensing_type, :sku, :licensor, presence: true
  validates :name, length: { in: 3..255 }
  validates :sku, length: { in: 1..255 }
  validates :licensing_type, inclusion: {
    in:      License.licensing_types.keys,
    message: '%{value} is not a valid licensing type'
  }
  validates :status, inclusion: {
    in:      License.statuses.keys,
    message: '%{value} is not a valid status'
  }

  belongs_to :licensor
  has_many :license_fees, dependent: :destroy
  has_many :license_mappings, dependent: :destroy
  has_many :plans,
           through: :license_mappings,
           source: :mappable,
           source_type: 'Plan'
  has_many :plan_resources,
           through: :license_mappings,
           source: :mappable,
           source_type: 'PlanResource'

  accepts_nested_attributes_for :license_fees, allow_destroy: true
  accepts_nested_attributes_for :license_mappings, allow_destroy: true
end
