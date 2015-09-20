class CreateJoinTableEntryTag < ActiveRecord::Migration
  def change
    create_join_table :Entries, :Tags do |t|
      # t.index [:entry_id, :tag_id]
      # t.index [:tag_id, :entry_id]
    end
  end
end
