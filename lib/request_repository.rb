require_relative './request'
require_relative './database_connection'

class RequestsRepository
    def all
        #returns all requests
        sql = "SELECT id, booker_id, lister_id, property_id, date, confirmed FROM requests;"
        result_set = DatabaseConnection.exec_params(sql,[])

        requests = []
        result_set.each do |result|
            request = Request.new
            request.id = result["id"]
            request.booker_id = result['booker_id']
            request.lister_id = result['lister_id']
            request.property_id = result['property_id']
            request.date = result['date']
            request.confirmed = result['confirmed']

            requests << request
        end
        return requests
    end

    def find_request(request_id)
        sql = 'SELECT id, booker_id, lister_id, property_id, date, confirmed FROM requests WHERE id = $1;'
        sql_param = [request_id]
        result = DatabaseConnection.exec_params(sql,sql_param)
        if result.to_a.length == 0
            return nil
        else
            request = Request.new
            request.id = result[0]["id"]
            request.booker_id = result[0]['booker_id']
            request.lister_id = result[0]['lister_id']
            request.property_id = result[0]['property_id']
            request.date = result[0]['date']
            request.confirmed = result[0]['confirmed']

            return request
        end
    end

    def find_request_by_prop(property_id)
        sql = 'SELECT id, booker_id, lister_id, property_id, date, confirmed FROM requests WHERE id = $1;'
        sql_param = [property_id]
        result = DatabaseConnection.exec_params(sql,sql_param)
        if result.to_a.length == 0
            return nil
        else
            request = Request.new
            request.id = result[0]["id"]
            request.booker_id = result[0]['booker_id']
            request.lister_id = result[0]['lister_id']
            request.property_id = result[0]['property_id']
            request.date = result[0]['date']
            request.confirmed = result[0]['confirmed']

            return request
        end
    end

    def create(request)
        sql = 'INSERT INTO requests (booker_id, lister_id, property_id, date, confirmed) VALUES ($1, $2, $3, $4, $5);'
        params = [request.booker_id,
        request.lister_id,
        request.property_id,
        request.date,
        request.confirmed]
        DatabaseConnection.exec_params(sql,params)
    end

    def create_request(booker_id, lister_id, property_id, date, confirmed)
        request = Request.new
        request.booker_id = booker_id
        request.lister_id = lister_id
        request.property_id = property_id
        request.date = date
        request.confirmed = confirmed
        repo = RequestsRepository.new
        repo.create(request)
    end

    def requests_for_me(lister_id)
        sql = "SELECT requests.id,users.name AS booker_name,users.email AS booker_email,properties.name AS property,properties.price,requests.date,requests.confirmed 
        FROM requests 
        JOIN users ON users.id = requests.booker_id
        JOIN properties ON properties.id = requests.property_id
        WHERE requests.lister_id=$1;"

        sql_param = [lister_id]
        result_set = DatabaseConnection.exec_params(sql,sql_param)
        requests = []

        if result_set.to_a.length == 0
            return nil
        else
            result_set.each do |result|
                request = Request.new
                request.id = result['id']
                request.booker_name = result['booker_name']
                request.booker_email = result['booker_email']
                request.property = result['property']
                request.price = result['price']
                request.date = result['date']
                request.confirmed = result['confirmed']

                requests << request
            end
            return requests
        end

    end

    def requests_from_me(booker_id)
        #lists all properties for the booker id
        sql = 'SELECT requests.id,
		properties.name AS property,
		properties.location,
		properties.description,
		properties.price,
		requests.date,
		requests.confirmed
        FROM requests
        JOIN properties ON properties.id = requests.property_id
        JOIN users ON users.id = requests.booker_id
        WHERE requests.booker_id = $1;'

        sql_param = [booker_id]
        result_set = DatabaseConnection.exec_params(sql,sql_param)
        requests = []
        if result_set.to_a.length == 0
            return nil
        else
            result_set.each do |result|
                request = Request.new
                request.id = result["id"]
                request.property = result['property']
                request.location = result['location']
                request.description = result['description']
                request.price = result['price']
                request.date = result['date']
                request.confirmed = result['confirmed']

                requests << request
            end
            return requests
        end
    end


    def confirm_request(request_id,change)
        if change == 1
            sql = "UPDATE requests SET confirmed = 1 WHERE id=$1;"
        elsif change == 0
            sql = "UPDATE requests SET confirmed = 0 WHERE id=$1;"
        end
        sql_param = [request_id]
        DatabaseConnection.exec_params(sql,sql_param)

    end

    
end