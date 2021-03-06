ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative './models/link.rb'
require_relative './models/tag.rb'
require_relative 'data_mapper_setup.rb'

class Bookmark < Sinatra::Base

  get '/' do
    erb :login
  end

  post '/links' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.create(url: params[:url], title: params[:title])
    tags = params[:tags].split
    tags.each do |tag|
      link.tags << Tag.first_or_create(name: tag)
      link.save
    end
    redirect '/links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

end
