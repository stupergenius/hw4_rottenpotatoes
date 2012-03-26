class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  def movies_by_director
    movies = Movie.where(:director => self.director)
    return movies
  end
end
