# Resellers
class Reseller < ActiveRecord::Base
  validates :name, presence: true, length: { in: 3..255 }

  has_many :licensors
end
