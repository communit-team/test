class AddFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :oauth_token, :string
  end

  def down
    remove_column :users, :uid
    remove_column :users, :name
    remove_column :users, :oauth_token
  end
end
