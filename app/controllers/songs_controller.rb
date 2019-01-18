class SongsController < ApplicationController
    enable :sessions
    use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  get '/songs/new' do
    @genres = Genre.all
    @artists = Artist.all
    erb :'/songs/new'
  end

  post '/songs' do
    @song = Song.create(params[:song])

    if !params["genre"]["name"].empty?
      @song.genres << Genre.create(params["genre"])
    end

    @song.artist = Artist.find_or_create_by(params["artist"]) if !params["artist"][:name].empty?
    @song.save

    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'/songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    @genres = Genre.all
    @artists = Artist.all
    erb :'/songs/edit'
  end

  patch '/songs/:slug' do
    ####### bug fix
    if !params[:song].keys.include?("genre_ids")
      params[:song]["genre_ids"] = []
    end
    #######
    @song = Song.find_by_slug(params[:slug])
    @song.update(params["song"])

    if !params["genre"]["name"].empty?
      @song.genres << Genre.create(name: params["genre"]["name"])
    end

    @song.artist = Artist.find_or_create_by(params["artist"]) if !params["artist"][:name].empty?
    @song.save

    flash[:message] = "Successfully updated song."
    redirect "/songs/#{@song.slug}"
  end

end
