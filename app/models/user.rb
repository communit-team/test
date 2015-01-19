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
    user = User.find_by(auth.slice(:uid))
    @@new_user = !user
    where(auth.slice(:uid)).first_or_initialize.tap do |user|
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.number_of_followers = auth.extra.raw_info.followers_count
      user.screen_name = auth.extra.raw_info.screen_name
      user.profile_image_url = auth.extra.raw_info.profile_image_url.to_s,
      user.save!
    end
  end

  def fetch_followers(client)
    api_followers = client.followers
    current_index = 0

    api_followers.each do |follower|
      if not followers.map(&:uid).include?(follower.id.to_s)
        current_index += 1
        user = User.find_by(uid: follower.id) || create_with_twitter_params(follower)
        user.follow self, last_ten_percent(api_followers.to_a.size, current_index)
      end
    end

    followers.each do |follower|
      if not api_followers.map{|f| f.id.to_s}.include?(follower.uid)
        user = User.find_by(uid: follower.uid)
        user.unfollow self
      end
    end

  end

  def follow(user, new = true)
    active_relationships.create(following_id: user.id, new: new)
  end

  def unfollow(user)
    FollowRelation.find_by(following_id: id, follower_id: user.id).destroy
    UnfollowRelation.create(unfollowing_id: id, unfollower_id: user.id) rescue nil?
  end

  def new_followers
    User.where(id: [passive_relationships.where(new: :true).map(&:follower_id)]).all
  end

  def unfollowers
    User.joins('join unfollow_relations on users.id = unfollow_relations.unfollower_id').where('unfollow_relations.unfollowing_id = ?', id).all
  end

  private

  def last_ten_percent(total_size, current_index)
    not @@new_user or current_index > total_size * 0.9
  end

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
