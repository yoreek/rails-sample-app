# Charge
class Charge < ActiveRecord::Base
  enum status: [:active, :closed]
  belongs_to :subscription
end
