class AddNumberOfFollowersToUsers < ActiveRecord::Migration
  def up
    add_column :users, :number_of_followers, :integer
  end

  def down
    remove_column :users, :number_of_followers
  end
end
