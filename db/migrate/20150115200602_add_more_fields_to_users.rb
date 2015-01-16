class AddMoreFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :profile_image_url, :text
    add_column :users, :screen_name, :text
  end

  def down
    remove_column :users, :profile_image_url
    remove_column :users, :screen_name
  end
end
