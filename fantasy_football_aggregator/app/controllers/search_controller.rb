class SearchController < ApplicationController

  def index
   render 'index'
 end

 def search
  #Create Array of Hashes to hold the results from each account
  @resultsAll=Array.new

  current_user.accounts.each do |account|
    #Future versions, include logic for non-ESPN platforms

    if account.platform == "ESPN"

      #Sign in to ESPN fantasy football with Mechanize
      #Find a way to avoid repeating the sign in everytime the search is invoked.
      @espnAgent=Mechanize.new
      @espnAgent.get("http://games.espn.go.com/ffl/signin")
      espnLogin=@espnAgent.page.forms.first
      #pp espnLogin
      espnLogin.username=account.user_name
      espnLogin.password=account.password
      @espnAgent.submit(espnLogin)

      #Need to verify cookie values by reading cookies array and string parsing.  These are the proper values for the dsgn425 ESPN account
      #@espnAgent.cookies[2].value="{DD60E36C-BEA5-448F-A0E3-6CBEA5148FAF}"
      #@espnAgent.cookies[3].value="{'swid':'{DD60E36C-BEA5-448F-A0E3-6CBEA5148FAF}'}"
      #Automatically identify the espnAuth cookie and reformat value to include quotes
      i=0
      cookieParts=Array.new
      while i<@espnAgent.cookies.count
        if @espnAgent.cookies[i].name=="espnAuth"
          cookieParts=@espnAgent.cookies[i].value.chomp("}}").split("{")
          newValue="{'swid':'{#{cookieParts[2]}}'}"
          @espnAgent.cookies[i].value=newValue
          break
        end
        i=i+1
      end
      #Automatically identify SWID cookie and assign proper value from espnAuth
      j=0
      while j<@espnAgent.cookies.count
        if @espnAgent.cookies[j].name=="SWID"
          @espnAgent.cookies[j].value="{#{cookieParts[2]}}"
          break
        end
        j=j+1
      end

      #Player search for each league
      account.leagues.each do |league|

      #Create Hash with Account_ID, League_ID, and results

      #Go to search page
      #pp @espnAgent.cookies
      @espnAgent.get("http://games.espn.go.com/ffl/freeagency?leagueId=#{league.league_number}&teamId=#{league.team_number}&seasonId=#{Date.today.year}")
      #pp "http://games.espn.go.com/ffl/freeagency?leagueId=#{league.league_number}&teamId=#{league.team_number}&seasonId=#{Date.today.year}"
      espnSearch=@espnAgent.page.forms.first
      #pp espnSearch
      espnSearch.search=params[:lastNameInput]
      #pp params[:lastNameInput]
      #pp espnSearch.search
      espnSearch.submit

        #Put results page into Nokogiri object for parsing
        espnDoc=Nokogiri::HTML(@espnAgent.page.body)

        #Put player names, teams, positions from search results table into array
        resultsPlayers=Array.new

        espnDoc.css("td[class='playertablePlayerName']").each do |td|
          resultsPlayers.push td.text
        end

        #Put the availabilities into an array
        resultsAvail=Array.new
        a=espnDoc.css("tr").select{|tr| tr[:class].to_s.include? "pncPlayerRow"} #this gets rows from espn results table
        #ideally do something like a.select{|a| a.css("td")[2].text} but it won't work in terminal.  Do loop instead. a[0].css("td")[2].text works
        i=0
        while i<a.count
          resultsAvail.push a[i].css("td")[2].text
          i=i+1
        end

        #put all results into a hash to then push into the @resultsAll array
        resultsHash=Hash.new
        resultsHash={:platform => league.account.platform, :leagueName => league.name, :resultsPlayers => resultsPlayers, :resultsAvail => resultsAvail, :n => resultsAvail.count}

        @resultsAll.push resultsHash

      end

    end

    #this is where non-ESPN leagues would go

  end

  render 'results'
end

end

