# Subscription
class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :account

  after_save :create_charge

  private

  def create_charge
    Charge.create(
      subscription_id: id,
      amount:          PlanResource.where(plan_id: plan_id).sum(:amount),
      status:          :active,
      operate_from:    Date.today,
      operate_to:      Date.today
    )
  end
end
