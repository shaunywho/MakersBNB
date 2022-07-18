require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'



DatabaseConnection.connect('makersbnb')
DatabaseConnection.exec(File.read('./seeds/makers_bnb_seed.sql'))

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/user_repository'
  end



end 