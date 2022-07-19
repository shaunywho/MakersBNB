require_relative './user'
require_relative './database_connection'
DatabaseConnection.connect('makersbnb')
class UserRepository
    def entry_to_user(entry)
        user = User.new 
        user.id = entry['id']
        user.name = entry['name']
        user.email = entry['email']
        user.password = entry['password']
        return user
    end
    def all 
        users = []
        sql = 'SELECT * FROM users;'
        result = DatabaseConnection.exec_params(sql, [])
        result.each do |item|
            user = entry_to_user(item)
            users << user
        end 
        return users
    end 

    def find(email)
        sql = 'SELECT * FROM users WHERE email = $1;'
        params = [email]
        result = DatabaseConnection.exec_params(sql, params)
        if result.to_a.length>0
            entry = result[0]
            user = entry_to_user(entry)
            return user
        else
            return nil

        end 
    end
        
    def create(user)
        params = [user.name, user.email, user.password]
        result = DatabaseConnection.exec_params("INSERT INTO users (name, email, password) VALUES($1, $2, $3);", params)
    end

    def password_checker(email, password)
        result = DatabaseConnection.exec_params("SELECT password FROM users WHERE email = $1", [email])
        if result.to_a.length > 0
            if result[0]['password'] == password
                return true
            end 
        else
            return false
        end 
    end

end
