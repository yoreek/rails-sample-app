# Create subsriptions
class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.belongs_to :plan, index: true, foreign_key: true
      t.belongs_to :account, index: true, foreign_key: true
      t.date :start_date
    end
  end
end
