require_relative './user'
require_relative './database_connection'
DatabaseConnection.connect('users')
class UserRepository
    
    def self.instance
        @instance ||= self.new
    end

    def all 
        @users = []
        sql = 'SELECT * FROM users;'
        result = DatabaseConnection.exec_params(sql, [])
        result.each do |item|
            user = User.new 
            user.id = item['id']
            user.name = item['name']
            user.email = item['email']
            user.password = item['password']
            @users << user
        end 
        return @users
    end 

    def find(email)
        sql = 'SELECT * FROM users WHERE email = $1;'
        params = [email]
        result = DatabaseConnection.exec_params(sql, params)
        record = result[0]
        user = User.new
        user.id = record['id']
        user.name = record['name']
        user.email= record['email']
        user.password = record['password']
        return user
    end
        
    def self.create(name, email, password)
        params = [user.name, user.email, user.password]
        result = DatabaseConnection.query("INSERT INTO users (name, email, password) VALUES($1, $2, $3);", params)
        
    end

    def password_checker(email, password)
        result = DatabaseConnection.query("SELECT password FROM users WHERE email = $1")
        if result[0]['password'] == password
            return true
        else 
            return false
        end 
    end
end