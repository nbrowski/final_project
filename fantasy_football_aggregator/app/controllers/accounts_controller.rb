class AccountsController < ApplicationController
  before_action :check_if_owner, only: [:edit, :update, :destroy, :show]

  def check_if_owner
    account=Account.find(params[:id])
    if account.user_id != current_user.id
      redirect_to "/accounts", alert: "You do not have permission to access that account."
    end
  end

  def index
    @accounts = current_user.accounts
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

    @account = Account.new
    @account.platform = params[:platform]
    @account.password = params[:password]
    @account.user_name = params[:user_name]
    @account.user_id = current_user.id

    if iserror == true
      redirect_to "/accounts", :alert => "Wrong username or password"
    elsif @account.save
      #If verification successful then auto-add the leagues associated with that account
      #These are all of the league homepage links for the current season
      league_links=page.links_with(class: "leagueoffice-link", href: /seasonId=#{Date.today.year}/)
      #For each, pull out from the LeagueID and TeamID from url and League Name from link title.  Use to make a new League.
      pp league_links

      league_links.each do |link|

        pp "title: " + link.attributes[:title]
        pp "league num " + link.attributes[:href].split("=")[1].split("&")[0]
        pp "team num " + link.attributes[:href].split("=")[2].split("&")[0]

        @league = League.new
        @league.name=link.attributes[:title]
        @league.league_number=link.attributes[:href].split("=")[1].split("&")[0].to_i
        @league.team_number=link.attributes[:href].split("=")[2].split("&")[0].to_i
        @league.teamname=page.links_with(class: "clubhouse-link", href: /#{link.attributes[:href].split("?")[1]}/)[0].text
        @league.account_id=@account.id
        @league.save
        # if @league.save
        #   pp "League created"
        # else
        #   pp "League not created"
        #   pp @league.errors.full_messages.each {|message| puts message}
        # end

      end
        #get the unique league pages to add to notification
        string=""
        @account.leagues.each do |a|
          string=string+a.name+", "
        end
        string=string.chomp(", ")

        # pp @account
        # pp @account.leagues
        # pp string
        # pp League.find_by(:account_id => @account.id)

      #league_pages=@agent.page.links_with(href: /leagueoffice/)
      redirect_to "/accounts", :notice => "Account created successfully. Leagues added: #{string}"
    else
      render 'new'
    end
  end


  def edit
    @account = Account.find(params[:id])
  end

  def update

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

    @account = Account.find(params[:id])

    @account.platform = params[:platform]
    @account.password = params[:password]
    @account.user_name = params[:user_name]
    @account.user_id = current_user.id
    if iserror == true
      redirect_to "/accounts/edit", :alert => "Wrong username or password"
    elsif @account.save
      redirect_to "/accounts", :notice => "Account updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])

    @account.destroy

    redirect_to "/accounts", :notice => "Account and associated leagues deleted."
  end
end
