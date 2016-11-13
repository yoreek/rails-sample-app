# Plan resource
class PlanResource < ActiveRecord::Base
  belongs_to :plan
  has_many :mappings, as: :mappable
end
