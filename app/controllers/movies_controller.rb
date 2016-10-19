class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    sort = params[:sort] || session[:sort]
    
    @all_ratings = Movie.all_ratings
    @selected_ratings = []


	    if params[:commit] == "Refresh"
	      if params[:ratings] != nil
	        if params[:ratings].keys!=nil
	          @selected_ratings = params[:ratings].keys
	          session[:selected_ratings] = @selected_ratings 
	       # else
	       #   @all_ratings.each do |f|
	       #     @selected_ratings << f
	       #   end
	        end
	    	  # session[:selected_ratings] = @selected_ratings 
	    	  # session[:selected_ratings] = params[:ratings].keys
	      end
	   # else
	   #   @all_ratings.each do |f|
	   #      @selected_ratings << f
	   #   end
	    end
	    
	      
	    if session[:selected_ratings]!=nil
	  	  @selected_ratings = session[:selected_ratings]
  	  else
  	    @all_ratings.each do |f|
	  	  	@selected_ratings << f
		    end
	    end 
	    
      @movies = Movie.where(rating: @selected_ratings)
      
      case sort
      when 'title'
        ordering,@title_header = {:order => :title}, 'hilite'
        @movies = Movie.where(rating: @selected_ratings).order("title ASC").all
      when 'release_date'
        ordering,@date_header = {:order => :release_date}, 'hilite'
        @movies = Movie.where(rating: @selected_ratings).order("release_date ASC").all
      end
      
      if params[:sort] != session[:sort]
        session[:sort] = sort
	    	flash.keep
	    	redirect_to :sort=>sort, :ratings=>@selected_ratings and return
      end
	    	

    	if params[:ratings] != session[:ratings] and @selected_tatings != {}
    		session[:sort] = sort
    		session[:ratings] = @selected_ratings
    		flash.keep
    		redirect_to :sort=>sort, :ratings=>@selected_ratings and return
    	end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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