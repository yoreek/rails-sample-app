# Create license fees
class CreateLicenseFees < ActiveRecord::Migration
  def change
    create_table :license_fees do |t|
      t.date :start_date
      t.decimal :amount, precision: 10, scale: 2, default: 0
      t.references :license, index: true, foreign_key: true
    end
  end
end
