# Create plans
class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
    end
  end
end
