class LeaguesController < ApplicationController
  before_action :check_if_owner, only: [:edit, :update, :destroy, :show]

  def check_if_owner
    league=League.find(params[:id])
    if league.account.user_id != current_user.id
      redirect_to "/leagues", alert: "You do not have permission to access that league."
    end
  end


  def index
    @leagues = current_user.leagues
  end

  def show
    @league = League.find(params[:id])
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new
    @league.team_number = params[:team_number]
    @league.name = params[:name]
    @league.league_number = params[:league_number]
    @league.account_id = params[:account_id]
    @league.teamname = params[:teamname]

    if @league.save
      redirect_to "/leagues", :notice => "League created successfully."
    else
      render 'new'
    end
  end

  def edit
    @league = League.find(params[:id])
  end

  def update
    @league = League.find(params[:id])

    @league.team_number = params[:team_number]
    @league.name = params[:name]
    @league.league_number = params[:league_number]
    @league.account_id = params[:account_id]
    @league.teamname = params[:teamname]

    if @league.save
      redirect_to "/leagues", :notice => "League updated successfully."
    else
      render 'edit'
    end
  end

  def destroy
    @league = League.find(params[:id])

    @league.destroy

    redirect_to "/leagues", :notice => "League deleted."
  end
end
