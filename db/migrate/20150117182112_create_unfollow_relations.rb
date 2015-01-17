class CreateUnfollowRelations < ActiveRecord::Migration
  def change
    create_table :unfollow_relations do |t|
      t.integer :unfollower_id
      t.integer :unfollowing_id

      t.timestamps
    end
    add_index :unfollow_relations, :unfollower_id
    add_index :unfollow_relations, :unfollowing_id
    add_index :unfollow_relations, [:unfollower_id, :unfollowing_id], unique: true
  end

  def down
    drop_table :unfollow_relations
  end
end
