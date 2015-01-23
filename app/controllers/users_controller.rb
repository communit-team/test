class UsersController < ApplicationController

  before_action :make_follower_old, except: [:new_follower, :unfollower]
  before_action :delete_unfollower, except: [:new_follower, :unfollower]

  def new_follower
    new_follower = get_new_follower_by_index(params[:index].to_i)
    render json: new_follower.to_json
  end

  def unfollower
    unfollower = get_unfollower_by_index(params[:index].to_i)
    render json: unfollower.to_json
  end

  def follow
    user = User.find params[:id]
    if user
      current_user.follow user
      #call twitter API
    end
    new_user = get_new_user(params[:callback_container],params[:index].to_i)
    render json: new_user.to_json
  end

  def unfollow
    user = User.find params[:id]
    if user
      current_user.unfollow user rescue nil?
      #call twitter API
    end
    new_user = get_new_user(params[:callback_container],params[:index].to_i)
    render json: new_user.to_json
  end

  def say_hi
    #call API
    new_user = get_new_user(params[:callback_container],params[:index].to_i)
    render json: new_user.to_json
  end

  def dismiss_new_follower
    new_follower = get_new_follower_by_index(params[:index].to_i)
    render json: new_follower.to_json
  end

  def dismiss_unfollower
    unfollower = get_unfollower_by_index(params[:index].to_i)
    render json: unfollower.to_json
  end

  private

  def delete_unfollower
    ur = UnfollowRelation.find_by(unfollower_id: params[:id], unfollowing_id: current_user.id)
    if ur
      ur.delete
    end
  end

  def make_follower_old
    fr = FollowRelation.find_by(follower_id: params[:id], following_id: current_user.id)
    if fr
      fr.update_attributes(new: :false)
    end
  end

  def get_new_user(callbackContainer, index)
    if callbackContainer == "#new-unfollowers-container"
      return get_unfollower_by_index(index)
    end
    if callbackContainer == "#new-followers-container"
      return get_new_follower_by_index(index)
    end
  end

  def get_new_follower_by_index(index)
    json = {}
    new_followers = current_user.new_followers
    new_follower = new_followers[-index] if new_followers
    if new_follower
      json.merge! new_follower.attributes
      json[:following] = current_user.following? new_follower
    else
      json = nil
    end
    json
  end

  def get_unfollower_by_index(index)
    json = {}
    unfollowers = current_user.unfollowers
    unfollower = unfollowers[-index] if unfollowers
    if unfollower
      json.merge! unfollower.attributes
      json[:following] = current_user.following? unfollower
    else
      json = nil
    end
    json
  end

end
