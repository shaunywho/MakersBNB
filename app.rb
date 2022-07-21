require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/property_repository'
require_relative 'lib/request_repository'

DatabaseConnection.connect('makersbnb')
#DatabaseConnection.exec(File.read('./seeds/makers_bnb_seeds.sql'))

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
    also_reload 'lib/property_repository'
    also_reload 'lib/request_repository'
  end

  enable :sessions

  def in_session?
    if session[:id] && session[:name] && session[:email] != nil
      return true
    else
      return false
    end 
  end 
  def set_session(id, name, email)
    session[:id],session[:name], session[:email] = id, name, email
  end 

  get '/' do
    # button to login 
    @error = false
    return erb(:index) # form for login in and redirect to user page
  end 
  
  get '/signup' do 
    if in_session?
      return erb(:user)
    else 
      return erb(:signup) # form for signup and redirect to user page
    end 
  end
  
  post '/' do
    email = params[:email] 
    password = params[:password]
    user_repo = UserRepository.new
    user = user_repo.login(email, password)
    if user !=nil
      set_session(user.id, user.name, user.email)
      return redirect '/user'
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
        set_session(user.id, user.name, user.email)
        return redirect '/user'
      else
        @error = true
        return erb(:signup)
      end
      
  end

  get '/create_property' do 
    if in_session?
      return erb(:create_property)
    else
      return erb(:index)
    end
  end
  
  post '/create_property' do
      property_repo = PropertyRepository.new
    if in_session?
      property_repo.create_property(params[:name], params[:location], params[:description], params[:price],'t', session[:id])
      redirect('/properties')
    else
      return erb(:index)
    end 
  end
  
  get '/create_request/:id' do 
    repo = RequestsRepository.new
    repo3 = PropertyRepository.new
    if in_session?
      @property = repo3.find(params[:id])

      params = [session[:id], @property.user_id, @property.id, (Date.today.year).to_s,'0']
      repo.create_request(params)
      return erb(:create_request)
    else 
      return erb(:index)
    end
  end 
  
  get '/properties' do
      @properties = PropertyRepository.new.all
      p @properties.length
    if in_session?
      # property's details
      return erb(:properties)
    else
      return erb(:index)
    end 
  end

  get '/properties/:id' do
    if in_session?
      @property = PropertyRepository.new.find(params[:id]) 
      # buttons to user
      # buttons to request  
      return erb(:property_id)
    else
      return erb(:index)
    end 
  end 

  get '/requests/:id' do
    repo = RequestsRepository.new
    repo2 = UserRepository.new
    repo3 = PropertyRepository.new

    if in_session? 
      @request_object = repo.find_request(params[:id])
      @user = repo2.find_id(@request_object.lister_id)
      @property = repo3.find(@request_object.property_id)
      return erb(:request_id)
    else
      return erb(:index)
    end
  end

  
  
  get '/requests_to_me' do 
    if in_session?
      return erb(:requests_to_me)
    else
      return erb(:index)
    end
  end

  post '/requests_to_me/:id' do
    if in_session?
    # confirm request
      redirect '/requests_to_me'
    else
      return erb(:index)
    end 
  end

  get '/user' do
    if in_session?
      @name = session[:name]
      @email = session[:email]
    # user details
    # buttons to properties
    # buttons to request
      return erb(:user)
    else
      return erb(:index)
    end 

  end

  get '/requests' do
    repo = RequestsRepository.new
    #fix when there are no requests from me for for me
    #@requests_from_me = repo.requests_from_me(session[:id])
    if in_session?
      @requests_from_me = repo.requests_from_me(session[:id])
      p repo.requests_from_me(session[:id])
      @requests_for_me = repo.requests_for_me(session[:id])
      p repo.requests_for_me(session[:id])
      return erb(:requests)
    else
      return redirect '/'
    end
    
  end
  
  post 'request_confirmation/:id' do
    repo = RequestsRepository.new
    if in_session?
      request_param = params[:id]
      @confirm = repo.confirm_request(request_param, 1)
    else
      return erb(:index)
    end
  end
  
  get '/logout' do
    session.clear
    return erb(:index)
  end 


end 
