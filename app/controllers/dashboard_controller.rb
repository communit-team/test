class DashboardController < ApplicationController
  def index
    render text: client.home_timeline
  end
end
