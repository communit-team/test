class DashboardController < ApplicationController
  def index
    current_user.fetch_followers client #delayed job
    render text: client.home_timeline
  end
end
