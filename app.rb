require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
# require_relative 'lib/property_repository'
require_relative 'lib/request_repository'



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
    success = user_repo.password_checker(email, password)
    if success
      user = user_repo.find(email)
      session[:id] = user.id
      redirect('/user_page')
    else
      @error = true
      return erb(:index)
      
    end 
    # if loging in is successful
  end 
  
  post '/signup' do

    # if loging up is successful
      # session[id] = user.id
      return redirect('/user_page')
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
  
  get '/requests_to_me' do 
    return erb(:requests_to_me)
  end

  post '/requests_to_me/:id' do
    # confirm request
    redirect '/requests_to_me'
  end

  get '/user_page' do 
    # user details
    # buttons to properties
    # buttons to request
  end

  get '/requests' do
    repo = RequestsRepository.new
    #@requests_from_me = repo.requests_from_me(session[:id])
    @requests_from_me = repo.requests_from_me(1)
    @requests_for_me = repo.requests_for_me(2)
    puts @requests_from_me[0].property

    return erb(:requests)
  end

  post 'request_confirmation/:id' do
    repo = RequestsRepository.new
    request_param = params[:id]
    @confirm = repo.confirm_request(request_param, 1)

  end
end