# Create plans
class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      has_many :plan_resources
    end
  end
end
