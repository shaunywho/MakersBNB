require_relative '../app'
require "spec_helper"
require "rack/test"
require 'database_connection'


RSpec.describe Application do

  include Rack::Test::Methods

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
        expect(response.body).to include(' <input type="text" name="email" /> ')
        expect(response.body).to include('<input type="password" name="password" />')
    end 

    it 'returns ' do 
    end
  end

  context 'POST /login' do 
    it 'returns user_page' do 
        response = post('/login', email: 'shaunho@gmail.com', password: 'password')
        expect(response.status).to eq 200
        expect(response.body).to include('Name:')
    end 

    it 'fails when invalid email and password are provided' do 
      response = post('/login', email: 'shaunho@gmail.com', password: 'wrongpassword')
      expect(response.status).to eq 200
      expect(response.body).to include('Password or Email invalid')
    end 

  end

  context 'POST /signup' do
    it 'returns user_page' do
      response = post('/signup', name: 'testname', email: 'test@gmail.com', password: 'test')
      expect(response.status).to eq 200
      expect(response.body).to include('Name:')
    end 

    it 'fails when trying to signup with a used email' do
      response = post('/signup', name: 'testname', email: 'shaunho@gmail.com', password: 'wrongpassword')
      expect(response.status).to eq 200
      expect(response.body).to include('Password or Email invalid')

    end 

  end 


      



end 
