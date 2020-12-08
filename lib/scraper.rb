require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open("https://learn-co-curriculum.github.io/student-scraper-test-page/index.html"))
    students = []
    doc.css("div.roster-cards-container").each do |key|
      key.css(".student-card a").each do |keys|
        link = "#{keys.attr("href")}"
        name = keys.css("h4.student-name").text
        location = keys.css("p.student-location").text
       students << {:name => name, :location => location, :profile_url => link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    hash = {}
    links = doc.css("div.social-icon-container").children.css("a").map {|key| key.attribute('href').value}
    links.each do |keys|
    if keys.include?("twitter")
      hash[:twitter] = keys
    elsif keys.include?("linkedin")
      hash[:linkedin] = keys
    elsif keys.include?("github")
      hash[:github] = keys
    else 
      hash[:blog] = keys
    
    
    end
    end
    hash[:profile_quote] = doc.css("div.profile-quote").text if doc.css("div.profile-quote").text
    hash[:bio] = doc.css("div.description-holder p").text if doc.css("div.description-holder p").text
    
    hash
  
  end

end

