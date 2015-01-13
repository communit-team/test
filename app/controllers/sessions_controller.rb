class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(auth_hash)
    session[:user_id] = user.id
    session[:access_token] = auth_hash['credentials']['token']
    session[:access_token_secret] = auth_hash['credentials']['secret']
    redirect_to '/dashboard'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
