require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/property_repository'
require_relative 'lib/request_repository'

DatabaseConnection.connect('makersbnb')
DatabaseConnection.exec(File.read('./seeds/makers_bnb_seeds.sql'))

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
    also_reload 'lib/property_repository'
    also_reload 'lib/request_repository'
  end

  enable :sessions

  def in_session?
    if session[:id] != nil
      return true
    else
      return false
    end 
  end 
  def set_session(id)
    session[:id] = id
  end 

  post '/add_photo' do
    tempfile = params[:file][:tempfile] 
    user = UserRepository.new.find_id(session[:id])
    user_repo = UserRepository.new
    user_repo.add_photo(user, tempfile)
    redirect '/user'
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
      set_session(user.id)
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
        set_session(user.id)
        return redirect '/user'
      else
        @error = true
        return erb(:signup)
      end
      
  end


  get '/create_property' do 
    return erb(:create_property)
  end
  
  post '/create_property' do
    property_repo = PropertyRepository.new
    property_repo.create_property(params[:name], params[:location], params[:description], params[:price],'t', session[:id])
    redirect('/properties')
  end

  post '/create_request' do
      return redirect('/requests_by_me')
  end

  get '/properties' do
    @properties = PropertyRepository.new.all
    # property's details
    return erb(:properties)
  end

  get '/properties/:id' do
    @property = PropertyRepository.new.find(params[:id]) 
    # buttons to user
    # buttons to request  
    return erb(:property_id)
  end 

  post '/requests/:id' do
    property_repo = PropertyRepository.new
    request_repo = RequestsRepository.new
    request_object = request_repo.find_request(params[:id])
    property = property_repo.find(request_object.property_id)
    confirm_deny = params[:confirm].to_i
    if confirm_deny == 1
      request_repo.find_requests_by_property_id(property.id).each{|request| request_repo.confirm_request(request.id,0)}
      property_repo.update_availability(property.id, 'f')
    end
    request_repo.confirm_request(request_object.id, confirm_deny)
    redirect "/requests/#{params[:id]}"
  end

  

  get '/requests/:id' do 
    request_repo = RequestsRepository.new
    user_repo = UserRepository.new
    property_repo = PropertyRepository.new
    @request_object = request_repo.find_request(params[:id])
    @lister = user_repo.find_id(session[:id])
    @property = property_repo.find(@request_object.property_id)
    return erb(:request_id)
  end


  
  get '/requests_to_m' do 
    return erb(:requests_to_me)
  end

  post '/requests_to_me/:id' do
    # confirm request
    redirect '/requests_to_me'
  end

  get '/user' do
    if in_session?
      @user = UserRepository.new.find_id(session[:id])
      
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
    request_param = params[:id]
    @confirm = repo.confirm_request(request_param, 1)

  end
  
  get '/logout' do
    session.clear
    return erb(:index)
  end 


end 
