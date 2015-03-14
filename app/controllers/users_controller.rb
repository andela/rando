class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :read, User
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
    # params[:users_ids]
    # client = SubledgerClient.new
    # client.allocate(user, params[:amount])
    redirect_to users_path
  end
end