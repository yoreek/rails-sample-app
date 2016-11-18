# Create licenses
class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name
      t.integer :licensing_type, default: 0
      t.integer :status, default: 0
      t.references :licensor, index: true, foreign_key: true
    end
  end
end
