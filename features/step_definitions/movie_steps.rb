# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  e1_index = page.body.index(e1)
  assert e1_index != nil, "'#{e1}' not found in page body"
  
  e2_index = page.body.index(e2)
  assert e2_index != nil, "'#{e2}' not found in page body"
  
  assert e1_index < e2_index, "'#{e2}' displayed before '#{e1}' in page body"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(/,\s?/)
  ratings.each do |rating|
    steps %{
      When I #{uncheck}check "ratings_#{rating}"
    }
  end
end

Then /I should (not )?see all of the movies/ do |should_not, movies_table|
  movies_table.hashes.each do |movie|
    movie_title = movie['title']
    steps %{
      Then I should #{should_not}see "#{movie_title}"
    }
  end
end

Then /the director of "(.*)" should (not )?be "(.*)"/ do |movie_title, should_not, director|
  movie = Movie.where(:title => movie_title).first
  assert movie != nil, "no movie named '#{movie_title}' found"
  if should_not
    assert movie.director != director
  else
    assert movie.director == director
  end
end
