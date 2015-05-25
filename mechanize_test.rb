require 'mechanize'

@agent=Mechanize.new

#first sign in to ESPN fantasy football

@agent.get("http://games.espn.go.com/ffl/signin")

  login_form=@agent.page.forms.first

  login_form.username="dsgn425"
  login_form.password="password"

  @agent.submit(login_form)

#check page title to see that log in worked
puts @agent.page.title

#look at cookies.  See that espnAuth and SWID are there
puts @agent.cookies

#Now go to the league page

league_page=@agent.page.links_with(href: /leagueId/).first.href

#Look at link.  It should be "http://games.espn.go.com/ffl/clubhouse?leagueId=11584&teamId=2&seasonId=2015"
puts league_page

@agent.get(league_page)

#Check page title to see that click worked - It should NOT say "Sign In" but rather "Team Bar - Free Fantasy Football - ESPN"

puts @agent.page.title

#look to see that cookies are still there
puts @agent.cookies


