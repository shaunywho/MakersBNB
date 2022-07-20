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
    it 'returns user_page' do 
        response = post('/', email: 'shaunho@gmail.com', password: 'password')
        expect(response).to redirect_to('/user_page')
    end 

    it 'fails when invalid email and password are provided' do 
      response = post('/', email: 'shaunho@gmail.com', password: 'wrongpassword')
      expect(response.status).to eq 200
      expect(response.body).to include('Password or Email invalid')
    end 

  end

  context 'POST /signup' do

    it 'returns user_page' do
      response = post('/signup', name: 'testname', email: 'test@gmail.com', password: 'test')
      expect(response).to redirect_to('/user_page')
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
      
  context 'GET /user_page' do
    it 'redirects to / when no session' do
    response = get('/user_page')
    expect(response.status).to eq 200
    expect(response.body).to include('<input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="email">')
    end 

  end 
end 
