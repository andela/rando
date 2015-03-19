class DistributorsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, :distributors
    @users = User.order(name: :asc).decorate
  end

  def new
    authorize! :allocate_money, User
    @users_ids = params[:users_ids]
    respond_to do |format|
      format.js
    end
  end

  def create
    authorize! :allocate_money, User
    client = UserFundManager.new current_user
    user_ids = params[:users].split(" ").map(&:to_i)

    response = client.allocate(user_ids, params[:amount], params[:reason])
    if response == 202
      flash[:notice] = 'Money distributed successfully'
    else
      flash[:notice] = 'There was a problem distributing money'
    end
    redirect_to distributors_path
  end
end