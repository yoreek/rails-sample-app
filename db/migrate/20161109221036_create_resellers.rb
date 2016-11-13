# Create resellers
class CreateResellers < ActiveRecord::Migration
  def change
    create_table :resellers do |t|
      t.string :name
      t.has_many :licensors
    end
  end
end
