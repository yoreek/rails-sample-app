# Create resellers
class CreateResellers < ActiveRecord::Migration
  def change
    create_table :resellers do |t|
      t.string :name
    end
  end
end
