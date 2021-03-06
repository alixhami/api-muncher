require 'httparty'

class EdamamApiWrapper
  APP_ID = ENV["APP_ID"]
  APP_KEY = ENV["APP_KEY"]
  BASE_URL = "https://api.edamam.com/search?app_id=#{APP_ID}&app_key=#{APP_KEY}"

  def self.get_recipes(search_term, page)
    return [] if search_term.blank?
    from, to = page_to_pages(page)

    url = "#{BASE_URL}&q=#{search_term}&from=#{from}&to=#{to}"
    results = HTTParty.get(url)

    Recipe.create_multiple_from_edamam(results["hits"])
  end

  def self.find_by_uri(uri)
    url = "#{BASE_URL}&r=#{uri}"
    results = HTTParty.get(url)

    # The API returns "<" when it cannot find a recipe given a URI
    return nil if results.blank? || results.first == "<"
    Recipe.create_from_edamam(results.first)
  end

  private
  def self.page_to_pages(page)
    to = (page * 10)
    from = to - 10

    [from, to]
  end
end
