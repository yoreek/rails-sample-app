# Create licensors
class CreateLicensors < ActiveRecord::Migration
  def change
    create_table :licensors do |t|
      t.string :name
      t.integer :status, default: 0
      t.belongs_to :reseller, index: true, foreign_key: true
    end
  end
end
