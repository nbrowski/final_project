class SearchController < ApplicationController
  # before_action :check_for_league
  # def check_for_league
  #   if current_user.accounts.count==0
  #     #Need to add notification too.  Perhaps on the accounts index
  #     redirect_to "/accounts"
  #   end
  # end

  def index
   render 'index'
 end

 def search

  #Create Array of Hashes to hold the results from each account
  @resultsAll=Array.new
  #*** Test new idea, see bottom
  @resultsAll2=Array.new
  #**** end

  current_user.accounts.each do |account|
    #Future versions: include logic for non-ESPN platforms.  Might need to use one agent for all platforms in order to be able to save the cookies across sessions.

    if account.platform == "ESPN"

      #Sign in to ESPN fantasy football with Mechanize
      @espnAgent=Mechanize.new

      #Skip sign in if already signed in previously in the session. ie if cookies are present
      cookies = session[:login_cookies]

      #for testing
        #puts cookies

        if cookies=="" or cookies==nil then
        #for testing
        puts "***COOKIES ARE EMPTY***"
        @espnAgent.get("http://games.espn.go.com/ffl/signin")
        espnLogin=@espnAgent.page.forms.first
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

        #This will save the cookies across controller requests. But how can I distinguish cookies from multiple agents? Possible by using :espn_cookies rather than :login_cookies in session?
        stringio = StringIO.new
        @espnAgent.cookie_jar.save(stringio, session: true)
        cookies = stringio.string
        puts cookies
        session[:login_cookies] = cookies
      else
        #for testing
          #puts "***COOKIES ARE LOADED FROM SAVED***"
          #pp cookies
          #cookies = session[:login_cookies]
          #pp cookies
          @espnAgent.cookie_jar.load StringIO.new(cookies)
        end

      #Player search for each league
      account.leagues.each do |league|

      #Create Hash with Account_ID, League_ID, and results

      #Go to search page
      @espnAgent.get("http://games.espn.go.com/ffl/freeagency?leagueId=#{league.league_number}&teamId=#{league.team_number}&seasonId=#{Date.today.year}")
      pp "http://games.espn.go.com/ffl/freeagency?leagueId=#{league.league_number}&teamId=#{league.team_number}&seasonId=#{Date.today.year}"
      pp @espnAgent.cookies
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

        #Put the availabilities and add/trade/drop links into an array
        a=espnDoc.css("tr").select{|tr| tr[:class].to_s.include? "pncPlayerRow"} #this gets rows from espn results table
        #ideally do something like a.select{|a| a.css("td")[2].text} but it won't work in terminal.  Do loop instead. a[0].css("td")[2].text works
        #*** Try this: each row from espn is a self-contained hash with platform and league name.  Total results is then array of these hashes.  The array can then be sorted on player name to arrange results output by player rather than by current league.
        i=0
        while i<a.count
          #Owned by / Availability
          resultAvail=a[i].css("td")[2].text

          #Link to Add/Trade/Drop player
          linkpath=a[i].css("td")[3].css("a")[0].attributes["href"].value.split("'")[1]
          linkurl="http://games.espn.go.com"+linkpath
          linkAction=a[i].css("td")[3].css("a")[0].attributes["title"].value


          resultHash=Hash.new
          resultHash={
            :platform => league.account.platform,
            :leagueName => league.name,
            :resultPlayer => resultsPlayers[i],
            :resultAvail => resultAvail,
            :resultLink => linkurl,
            :resultLinkAction => linkAction
          }

          @resultsAll.push resultHash
          i=i+1
        end
        #sort results by player name
        @resultsAll.sort_by!{|hsh| hsh[:resultPlayer]}
      end

    end

    #this is where non-ESPN leagues would go

  end

  render 'results'
end

def addPlayerTest
  #This is a test for adding a player
  cookies = session[:login_cookies]
  @espnAgent=Mechanize.new
  @espnAgent.cookie_jar.load StringIO.new(cookies)

  @espnAgent.get("http://games.espn.go.com/ffl/freeagency?leagueId=11584&amp;incoming=1&amp;trans=2_8416_-1_1001_2_20")

  @addPageHTML=Nokogiri::HTML(@espnAgent.page.body).to_html

end

def rosterfixtest

end

end

