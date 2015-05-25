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
puts @agent.cookies

#add Cookie

#cookie = Mechanize::Cookie.new :domain => '.go.com', :name => 'espnAuth', :value => {"swid":"{DD60E36C-BEA5-448F-A0E3-6CBEA5148FAF}"}, :path => '/', :expires => (Date.today + 1).to_s
#@agent.cookie_jar << cookie

#cookie2 = Mechanize::Cookie.new :domain => '.go.com', :name => 'SWID', :value => {DD60E36C-BEA5-448F-A0E3-6CBEA5148FAF}, :path => '/', :expires => (Date.today + 1).to_s
#@agent.cookie_jar << cookie2

#now go to the league page

league_page=@agent.page.links_with(href: /leagueId/).first.href

@agent.get(league_page)

#check page title to see that click worked

puts @agent.page.title
puts @agent.cookies
#BUT it took me back to the login page... why?


