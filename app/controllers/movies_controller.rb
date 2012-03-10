class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #session.clear
    if not session.has_key?(:movies_filter_params)
      session[:movies_filter_params] = {:sort => nil, :ratings => nil}
    end
    
    @highlighted_column = nil
    @all_ratings = Movie.ratings
    @selected_ratings = {}
    sort_order = ''
    ratings_condition = []
    
    valid_sorts = ['title', 'release_date']
    if params.include?(:sort) and valid_sorts.include?(params[:sort])
      sort_order = params[:sort] + ' ASC'
      @highlighted_column = params[:sort]
      session[:movies_filter_params][:sort] = params[:sort]
    elsif session[:movies_filter_params][:sort] != nil
      redirect_to movies_path(params.merge(session[:movies_filter_params]))
      return
    end
    puts params.merge(session[:movies_filter_params])
    
    if (params.include?(:ratings))
      @selected_ratings = params[:ratings]
      ratings_filter = []
      @selected_ratings.each do |rating, value|
        ratings_filter.push(rating) if @all_ratings.include? rating
      end
      
      if ratings_filter.length > 0
        session[:movies_filter_params][:ratings] = params[:ratings]
        ratings_condition = ['rating in (?)', ratings_filter]
      elsif session[:movies_filter_params][:ratings] != nil
        redirect_to movies_path(params.merge(session[:movies_filter_params]))
        return
      end
    else
      if params.include?(:commit)
        session[:movies_filter_params][:ratings] = nil
      elsif session[:movies_filter_params][:ratings] != nil
        redirect_to movies_path(params.merge(session[:movies_filter_params]))
        return
      end
    end
    
    @movies = Movie.find(:all, :order => sort_order, :conditions => ratings_condition)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
