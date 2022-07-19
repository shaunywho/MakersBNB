# require 'user_repository'
# require 'database_connection'
# RSpec.describe userRepository do 
#     def reset_user_table
#         seed_sql = File.read('spec/seeds.sql')
#         connection = PG.connect({ host: '127.0.0.1', dbname: 'users' })
#         connection.exec(seed_sql)
#     end
      
#     before(:each) do 
#         reset_user_table
#     end

#     it "returns all users" do
#         repo = UserRepository.new
#         users = repo.all
#         expect(user.length).to eq 1

#         expect(users[0].id).to eq "1" 
#         expect(users[0].name).to eq " "
#         expect(users[0].email).to eq ""
#         expect(user[0].password).to eq ''
#     end 
#     it "returns a single user" do 
#         repo = UserRepository.new
#         user = repo.find(1)

#         expect(user.id).to eq "1" 
#         expect(user.name).to eq " "
#         expect(user.email).to eq ""
#         expect(user.password).to eq ''
#     end 

#     it "creates new user" do 
#         repo = UserRepository.new
#         user = User.new
#         user.id = "5"
#         user.name = ''
#         user.email = ''
#         user.paassword = ''

#         repo.create(user)

#         users = repo.all
#         expect(users).to include(
#             have_attributes(
#                 id: user.id,
#                 name: user.name,
#                 email: user.email, 
#                 password: user.password
#             )
#         )
#     end 
#     it "checks password" do 
#         repo = UserRepository.new
#         user = repo.password_checker('example@text.com', 'A')
#         expect(user).to eq true
#     end
# end 