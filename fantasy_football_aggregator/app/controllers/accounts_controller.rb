class AccountsController < ApplicationController
  def index
    @accounts = Account.all
  end

  def show
    @account = Account.find(params[:id])
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new
    @account.platform = params[:platform]
    @account.password = params[:password]
    @account.user_name = params[:user_name]
    @account.user_id = current_user.id

    if @account.save
      redirect_to "/accounts", :notice => "Account created successfully."
    else
      render 'new'
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])

    @account.platform = params[:platform]
    @account.password = params[:password]
    @account.user_name = params[:user_name]
    @account.user_id = current_user.id

    if @account.save
      redirect_to "/accounts", :notice => "Account updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])

    @account.destroy

    redirect_to "/accounts", :notice => "Account deleted."
  end
end
