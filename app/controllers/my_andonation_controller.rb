class MyAndonationController < ApplicationController
  before_action :authenticate_user!

  def index
    @campaigns = current_user.campaigns.order(created_at: :desc).limit(4)
  end
end