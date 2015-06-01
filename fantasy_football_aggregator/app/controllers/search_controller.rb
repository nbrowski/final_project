class SearchController < ApplicationController

  def index
   render 'index'
 end

 def search

  current_user.accounts.each do |account|
    #Future versions, include logic for non-ESPN platforms
    if account.platform == "ESPN"
      #Sign in to ESPN fantasy football with Mechanize

      @espnAgent=Mechanize.new
      @espnAgent.get("http://games.espn.go.com/ffl/signin")
      espnLogin=@espnAgent.page.forms.first
      espnLogin.username=account.user_name
      login_form.password=account.password
      @espnAgent.submit(login_form)

      #Need to verify cookie values by reading cookies array and string parsing.  These are the proper values for the dsgn425 ESPN account
      #@agent.cookies[2].value="{DD60E36C-BEA5-448F-A0E3-6CBEA5148FAF}"
      #@agent.cookies[3].value="{'swid':'{DD60E36C-BEA5-448F-A0E3-6CBEA5148FAF}'}"

      #Player search for each league
      account.leagues.each do |league|
        @espnAgent.get("http://games.espn.go.com/ffl/freeagency?leagueId=#{league.league_number}&teamId=#{league.team_number}&seasonId=#{Date.today.year}")
        espnSearch=@espnAgent.page.forms.first
        espnSearch.search=arams[:lastNameInput]
        espnSearch.submit

        #Put results page into Nokogiri object for parsing
        espnDoc=Nokogiri::HTML(@espnAgent.page.body)
        #Put player names, teams, positions from search results table into array
        espn.league_Id
        espnDoc.css("td[class='playertablePlayerName']").each do |td|
          td.text
        end

      end

    end

  end

  render 'results'
end

end
