# Create subsriptions
class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.references :plan, index: true, foreign_key: true
      t.references :account, index: true, foreign_key: true
      t.date :start_date
    end
  end
end
