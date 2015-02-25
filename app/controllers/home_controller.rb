class HomeController < ApplicationController

  def index
    @campaigns = Campaign.order(created_at: :desc).limit(3).decorate
  end
end