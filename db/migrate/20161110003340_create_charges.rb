# Create charges
class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.integer :status, default: 0
      t.date :operate_from
      t.date :operate_to
      t.references :subscription, index: true, foreign_key: true
    end
  end
end
