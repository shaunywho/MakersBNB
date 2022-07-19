require_relative '../app'
require "spec_helper"
require "rack/test"
require 'database_connection'


RSpec.describe Application do

  include Rack::Test::Methods

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
    it 'returns ' do 
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





end 
