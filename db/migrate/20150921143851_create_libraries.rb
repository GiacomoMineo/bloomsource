class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :topic
      t.text :description
      t.references :creator, index: true
      t.timestamps null: false
  	end
  end
end
