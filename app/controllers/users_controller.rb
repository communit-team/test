class UsersController < ApplicationController

  def new_follower
    @new_follower = get_new_follower_by_index(params[:index].to_i)
    render json: @new_follower.to_json
  end

  def unfollower
    @unfollower = get_unfollower_by_index(params[:index].to_i)
    render json: @unfollower.to_json
  end

  def dismiss
    fr = FollowRelation.find_by(follower_id: params[:id], following_id: current_user.id)
    if fr
      fr.update_attributes(new: :false)
    end

    ur = UnfollowRelation.find_by(unfollower_id: params[:id], unfollowing_id: current_user.id)
    if ur
      ur.delete!
    end

    @new_follower = get_new_follower_by_index(params[:index].to_i)
    render json: @new_follower.to_json
  end

  private

  def get_new_follower_by_index(index)
    current_user.new_followers[-index]
  end

  def get_unfollower_by_index(index)
    current_user.unfollowers[-index]
  end

end
