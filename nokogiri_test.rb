require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://www.walmart.com/search/search-ng.do?search_query=Batman&adid=22222222220207904792&wmlspartner=wmtlabs&wl0=b&wl1=g&wl2=c&wl3=35547294591&wl4=&veh=sem"

doc = Nokogiri::HTML(open(url))

puts doc.at_css("title").text

doc.css(".tile-landscape").each do |item|
  title = item.at_css(".js-product-title").text
  price = item.at_css(".price-display").text[/\$[0-9\.]+/]
  puts "#{title} - #{price}"
  puts item.at_css(".js-product-title")[:href]
end
