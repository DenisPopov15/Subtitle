class SubsceneService
  require 'nokogiri'

  def initialize
    @subtitles_endpoint = "http://subscene.com/subtitles/"
    @search_by_title =  "title?q="
    @subtitle_folder = "/subtitles/"
    @lang = "english"
  end

  def search(query)
    links = []
    query = query.gsub(" ", "+")
    page_with_results = Nokogiri::HTML(open("#{@subtitles_endpoint}#{@search_by_title}#{query}"))
    results = page_with_results.css("div.search-result li")
    results.each do |result|
      links.push(result.css(".title a").first["href"].gsub(@subtitle_folder, ""))
    end
    links
  end

  def fetch_subtitle(url)
    page = Nokogiri::HTML(open("#{@subtitles_endpoint}#{url}"))

    img = page.css("div.poster a").first["href"]
    title = page.css(".top.left .header h1 span").text.strip
    link_to_imdb = page.css(".header h1 .imdb").first["href"]
    subtitle = page.css(".download #downloadButton").first["href"]

    { img: img, title: title, link_to_imdb: link_to_imdb, subtitle: subtitle }
  end

end
