class ImdbService
  def self.search(query)
    movies = Imdb::Search.new(query).movies
    unless movies.empty?
      movies[0]
    else
      nil
    end
  end
end

# movie = ImdbService.search(query)
# movie.id   # Can be easily find bu this id
# movie.url
# movie.rating