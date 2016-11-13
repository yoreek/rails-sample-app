# Plan
class Plan < ActiveRecord::Base
  has_many :plan_resources
  has_many :mappings, as: :mappable
  has_many :subscriptions
end
