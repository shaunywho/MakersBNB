require_relative '../app'
require "spec_helper"
require "rack/test"
require 'database_connection'


RSpec.describe Application do

  include Rack::Test::Methods

  RSpec::Matchers.define(:redirect_to) do |path|
    match do |response|
      uri = URI.parse(response.headers['Location'])
      response.status.to_s[0] == "3" && uri.path == path
    end
  end

  def reset_user_table
    seed_sql = File.read('seeds/makers_bnb_seeds.sql')
    DatabaseConnection.exec(seed_sql)
  end
  
  before(:each) do 
      reset_user_table
  end
  let(:app) { Application.new }

  context 'GET /' do 
    it 'return form' do 
        response = get('/')
        expect(response.status).to eq 200
        expect(response.body).to include('form')
        expect(response.body).to include('<input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="email">')
        expect(response.body).to include('<input type="password" class="form-control" id="exampleInputPassword1" name="password">')
    end 

  end

  context 'POST /' do 
    it 'returns user page' do 
        response = post('/', email: 'shaunho@gmail.com', password: 'password')
        expect(response).to redirect_to('/user')
    end 

    it 'fails when invalid email and password are provided' do 
      response = post('/', email: 'shaunho@gmail.com', password: 'wrongpassword')
      expect(response.status).to eq 200
      expect(response.body).to include('Password or Email invalid')
    end 

  end

  context 'POST /signup' do

    it 'returns user page' do
      response = post('/signup', name: 'testname', email: 'test@gmail.com', password: 'test')
      expect(response).to redirect_to('/user')
    end 

    it 'fails when trying to signup with a used email' do
      response = post('/signup', name: 'testname', email: 'shaunho@gmail.com', password: 'wrongpassword')
      expect(response.status).to eq 200
      expect(response.body).to include('Email already exists')

    end 
  
  end

  context 'GET /signup' do

    it 'returns signup page' do
      response = get('/signup')
      expect(response.status).to eq 200
      expect(response.body).to include('<input type="submit" value="Create User"/>')
    end 

  end 
      
  context 'GET /user' do
    it 'redirects to / when no session' do
    response = get('/user')
    expect(response.status).to eq 200
    expect(response.body).to include('<input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="email">')
    end 

  end 

  context 'GET /create_property' do
    it 'gets the create property page' do
      post('/', email: 'shaunho@gmail.com', password: 'password')
      response = get('/create_property')
      expect(response.status).to eq 200
      expect(response.body).to include("Create Property")
      expect(response.body).to include("price")
    end
  end 

  context 'POST /create_property' do
    it "redirects to /properties after pressing the 'create property' button" do
      post('/', email: 'shaunho@gmail.com', password: 'password')
      response = post('/create_property', name: 'name123', location: 'location123', description: 'fun description', price: 4, availability: 't', user_id: 1)
      expect(response.status).to eq 302
      expect(response).to redirect_to('/properties')
    end
  end

  context 'GET /properties' do
    it 'lists all available properties' do
      post('/', email: 'shaunho@gmail.com', password: 'password')
      response = get('/properties')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1 style="text-align:center">Find A Property</h1>')
    end 
  end

  context 'GET /properties/:id' do
    it 'gets the details for specific property' do
      post('/', email: 'shaunho@gmail.com', password: 'password')
      response = get('/properties/1')
      expect(response.status).to eq 200
      expect(response.body).to include('<br><h1 style="text-align:center">This is house1 page</h1>')
      expect(response.body).to include('<dt>Price per night:</dt>')
    end
  end
end 
