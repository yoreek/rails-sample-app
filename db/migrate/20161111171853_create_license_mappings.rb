# Create license mappings
class CreateLicenseMappings < ActiveRecord::Migration
  def change
    create_table :license_mappings do |t|
      t.references :mappable, polymorphic: true, index: true
      t.belongs_to :license, index: true, foreign_key: true
    end
  end
end
