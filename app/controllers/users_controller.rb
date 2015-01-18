class UsersController < ApplicationController

  def new_follower
    @new_follower = current_user.new_followers[-params[:index].to_i]
    render json: @new_follower.to_json
  end

end
