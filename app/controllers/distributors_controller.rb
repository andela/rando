class DistributorsController < ApplicationController
  def index
    @users = User.order(name: :asc).decorate
  end

  def new_allocation
    authorize! :allocate_money, User
    @users_ids = params[:users_ids]
    respond_to do |format|
      format.js
    end
  end

  def allocate_money
    authorize! :allocate_money, User
    client = SubledgerClient.instance
    user_ids = params[:users].split(" ").map { |s| s.to_i }

    response = client.allocate(user_ids, params[:amount], current_user, params[:reason])
    if response == 202
      flash[:notice] = 'Money distributed successfully'
    else
      flash[:notice] = 'There was a problem distributing money'
    end
    redirect_to distributors_path
  end
end