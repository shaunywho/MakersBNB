require 'user_repository'
require 'database_connection'
RSpec.describe UserRepository do 
    
    def reset_user_table
        seed_sql = File.read('seeds/makers_bnb_seeds.sql')
        DatabaseConnection.exec(seed_sql)
    end
      
    before(:each) do 
        reset_user_table
    end

    it "returns all users" do
        repo = UserRepository.new
        users = repo.all
        expect(users.length).to eq 4

        expect(users[0].id).to eq "1" 
        expect(users[0].name).to eq "Shaun"
        expect(users[0].email).to eq "shaunho@gmail.com"
        expect(users[0].password).to eq "password"
    end 
    it "returns a single user" do 
        repo = UserRepository.new
        user = repo.find("shaunho@gmail.com")

        expect(user.id).to eq "1" 
        expect(user.name).to eq "Shaun"
        expect(user.email).to eq "shaunho@gmail.com"
        expect(user.password).to eq "password"
    end 

    it "creates new user" do 
        repo = UserRepository.new
        user = User.new
        user.name = 'Sven'
        user.email = 'sven@test.com'
        user.password = 'svenson'
        repo.create(user)

        users = repo.all
        expect(users[-1]).to (
            have_attributes(
                name: user.name,
                email: user.email, 
                password: user.password
            )
        )
    end 
    it "checks password" do 
        repo = UserRepository.new
        user = repo.password_checker('shaunho@gmail.com', 'password')
        expect(user).to eq true
    end
end 
