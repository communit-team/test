class AddFieldsToFollowRelation < ActiveRecord::Migration
  def up
    add_column :follow_relations, :engaged, :boolean
    add_column :follow_relations, :new, :boolean, default: :true
  end

  def down
    remove_column :follow_relations, :engaged
    remove_column :follow_relations, :new
  end
end
