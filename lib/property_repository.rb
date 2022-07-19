require_relative './property'

class PropertyRepository
  def find(id)
    sql = 'SELECT * FROM properties WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])

    return get_properties(result_set)[0]
  end

  def all
    sql = 'SELECT * FROM properties;'
    result_set = DatabaseConnection.exec_params(sql, [])

    return get_properties(result_set)
  end

  def create(property)
    sql = 'INSERT INTO properties 
          (name, location, description, price, availability, user_id) 
          VALUES ($1, $2, $3, $4, $5, $6);'
    params = [property.name,
    property.location,
    property.description,
    property.price,
    property.availability,
    property.user_id]
    DatabaseConnection.exec_params(sql, params)
  end

  def my_properties(user_id)
    sql = 'SELECT * FROM properties WHERE user_id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [user_id])
    
    return get_properties(result_set)
  end

  def update_availability(id, value)
    sql = 'UPDATE properties SET availability = $2 WHERE id = $1;'

    DatabaseConnection.exec_params(sql, [id, value])
  end

  def property_owner(id)
    sql = 'SELECT properties.id, properties.name, properties.availability, properties.price, properties.description, users.name AS owner_name, users.email AS owner_email 
    FROM properties 
    JOIN users ON users.id = properties.user_id
    WHERE properties.user_id = $1;'

    result_set = DatabaseConnection.exec_params(sql, [id])
    properties = []
    result_set.each do |record|
      property = Property.new
      property.id = record['id'].to_i
      property.name = record['name']
      property.availability = record['availability']
      property.price = record['price']
      property.description = record['description']
      property.owner_name = record['owner_name']
      property.owner_email = record['owner_email']
      properties << property
    end
    return properties
  end
  
  private

  def get_properties(result_set)
    properties = []
    result_set.each do |record|
      property = Property.new
      property.id = record['id'].to_i
      property.name = record['name']
      property.location = record['location']
      property.description = record['description']
      property.price = record['price'].to_f
      property.availability = record['availability']
      property.user_id = record['user_id'].to_i
      properties << property
    end
    return properties
  end
end
