class User < ActiveRecord::Base

  has_many :active_relationships, class_name:  "FollowRelation",
           foreign_key: "follower_id",
           dependent:   :destroy

  has_many :passive_relationships, class_name:  "FollowRelation",
           foreign_key: "following_id",
           dependent:   :destroy

  has_many :following, through: :active_relationships, source: :following
  has_many :followers, through: :passive_relationships

  after_initialize :assign_defaults

  def self.from_omniauth(auth)
    where(auth.slice(:uid)).first_or_initialize.tap do |user|
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.save!
    end
  end

  def fetch_followers(client)
    new_number_of_followers = client.followers.count #O(1)
    delta = new_number_of_followers -  number_of_followers
    update(number_of_followers: new_number_of_followers) unless delta == 0
    get_and_save_new_followers client, delta
  end

  def get_and_save_new_followers(client, delta)
    new_followers = client.followers.take delta #O(1)
    new_followers.each do |new_follower|
      user = User.find_by(uid: new_follower.id) || create_with_twitter_params(new_follower)
      user.follow self
    end
  end

  def follow(user)
    active_relationships.create(following_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(following_id: user.id).destroy
  end

  private

  def create_with_twitter_params(params)
    User.create!(
      uid:  params.id,
      name: params.name,
      profile_image_url: params.profile_image_url.to_s,
      screen_name: params.screen_name,
      number_of_followers: params.followers_count
    )
  end

  def assign_defaults
    self.number_of_followers ||= 0
  end

end
