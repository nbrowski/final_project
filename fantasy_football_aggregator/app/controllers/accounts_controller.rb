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

    #Add verification step that username and password are correct
    if params[:platform] = "ESPN"
      #Sign in to ESPN fantasy football with Mechanize
      @espnAgent=Mechanize.new
      @espnAgent.get("http://games.espn.go.com/ffl/signin")
      espnLogin=@espnAgent.page.forms.first
      espnLogin.username=params[:user_name]
      espnLogin.password=params[:password]
      #If username and password are incorrect, Mechanize returns a page not found error. Capture that error below.
       begin
        page=@espnAgent.submit(espnLogin)
        rescue Exception => e
        page=e.page
        iserror = page.title.downcase.include? "page unavailable"
      end
    end

    #How to prevent account from being created
    @account = Account.new
    @account.platform = params[:platform]
    @account.password = params[:password]
    @account.user_name = params[:user_name]
    @account.user_id = current_user.id

   if iserror == true
        redirect_to "/accounts", :alert => "Wrong username or password"
    elsif @account.save
      #If verification successful then auto-add the leagues associated with that account
        #get the unique league pages

      #league_pages=@agent.page.links_with(href: /leagueoffice/)
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
