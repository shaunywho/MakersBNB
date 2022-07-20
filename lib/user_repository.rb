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
        user.profile_picture_path = entry['profile_picture_path']
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
    
    def find_by_id(id)
        sql = 'SELECT * FROM users WHERE id = $1;'
        params = [id]
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
        result = DatabaseConnection.exec_params("INSERT INTO users (name, email, password) VALUES($1, $2, $3) RETURNING ID;", params)[0]['id']
    end
    def add_photo(user)
        params = [user.profile_picture_path, user.id]
        DatabaseConnection.exec_params("UPDATE users SET profile_picture_path = $1 WHERE id = $2",params)
    end

    def login(email, password)
        user = find(email)   
        if user != nil
            if user.password  == password
                return user
            end 
        else
            return nil
        end 
    end

    def signup(name, email, password)
        user = find(email)
        if user == nil
            user = User.new
            user.name = name
            user.email = email
            user.password = password
            user.id = create(user)
            return user
        else
            return nil

        end 
    end 

end
