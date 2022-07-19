require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
# require_relative 'lib/property_repository'
# require_relative 'lib/request_repository'

DatabaseConnection.connect('makersbnb')
# DatabaseConnection.exec(File.read('./seeds/makers_bnb_seed.sql'))

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
  end

  enable :sessions

  get '/' do
    # button to login 
    return erb(:index) # form for login in and redirect to user_page
  end 
  
  get '/signup' do 
    return erb(:signup) # form for signup and redirect to user_page
  end
  
  post '/login' do
    email = params[:email] 
    password = params[:password]
    user_repo = UserRepository.new
    user = user_repo.login(email, password)
    if user
      session[:id] = user.id
      session[:name] = user.name
      session[:email] = user.email
      return erb(:user)
    else
      @error = true
      return erb(:index)
    end 
    # if loging in is successful
  end 
  
  post '/signup' do
      name = params[:name]
      email = params[:email]
      password = params[:password]
      user_repo = UserRepository.new
      user  = user_repo.signup(name,email,password)
      if user != nil
        session[:id] = user.id
        session[:name] = user.name
        session[:email] = user.email
        return redirect('/user_page')
      else
        @error = true
        return erb(:signup)
      end
      
  end
  
  post '/create_property' do

      return redirect('/properties_page')
  end

  post '/create_request' do
    
      return redirect('/requests_by_me')
  end

  get '/properties_page' do 
    # property's details
    # buttons to user
    # buttons to request 
    return erb(:properties)
  end

  get 'properties_page/:id' do 
    return erb(:property_info)
  end 


  get '/requests_by_me' do
    # lists properties I've requested
    # shows whether request is confirmed or not
    # buttons that redirect to properties_page/:id
    return erb(:requests_by_me)
  end
  
  get '/requests_to_m' do 
    return erb(:requests_to_me)
  end

  post '/requests_to_me/:id' do
    # confirm request
    redirect '/requests_to_me'
  end

  get '/user_page' do 
    @name = session[:name]
    @email = session[:email]
    # user details
    # buttons to properties
    # buttons to request
    return erb(:user)
  end

end 