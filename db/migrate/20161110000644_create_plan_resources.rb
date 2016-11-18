# Create plan resources
class CreatePlanResources < ActiveRecord::Migration
  def change
    create_table :plan_resources do |t|
      t.string :name
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.references :plan, index: true, foreign_key: true
    end
  end
end
