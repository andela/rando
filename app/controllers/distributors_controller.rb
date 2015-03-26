class DistributorsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, :distributors
    @users = User.order(name: :asc).decorate
  end

  def new_allocate
    authorize! :allocate_money, User
    @users_ids = params[:users_ids]
    respond_to do |format|
      format.js
    end
  end

  def allocate_money
    authorize! :allocate_money, User
    client = UserFundManager.new current_user
    user_ids = params[:users].split(' ').map(&:to_i)

    response = client.allocate(user_ids, params[:amount], params[:reason])
    if response == 202
      flash[:notice] = 'Money distributed successfully'
    else
      flash[:notice] = 'There was a problem distributing money'
    end
    redirect_to distributors_path
  end

  def new_withdraw
    authorize! :withdraw_money, User
    @user_id = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def withdraw_money
    authorize! :withdraw_money, User
    client = UserFundManager.new current_user
    user_id = User.find(params[:id])

    response = client.withdraw(user_id, params[:amount], params[:reason])
    if response == 202
      flash[:notice] = 'Money withdrawn successfully'
    else
      flash[:notice] = 'There was a problem withdrawing money'
    end
    redirect_to distributors_path
  end
end