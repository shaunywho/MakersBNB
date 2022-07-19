require 'property_repository'

def reset_users_table
  seed_sql = File.read('seeds/makers_bnb_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb' })
  connection.exec(seed_sql)
end

def reset_propertiess_table
  seed_sql = File.read('seeds/makers_bnb_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb' })
  connection.exec(seed_sql)
end

def reset_requests_table
  seed_sql = File.read('seeds/makers_bnb_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb' })
  connection.exec(seed_sql)
end
  
describe PropertyRepository do
  before(:each) do
    reset_users_table
    reset_propertiess_table
    reset_requests_table
  end

  it 'finds and returns one property using id' do
    repo = PropertyRepository.new
    properties = repo.find(1)

    expect(properties.id).to eq 1
    expect(properties.name).to eq 'house1'
    expect(properties.location).to eq 'place1'
    expect(properties.description).to eq 'description1'
    expect(properties.price).to eq 9.99
    expect(properties.availability).to eq "t"
    expect(properties.user_id).to eq 1
  end

  it 'returns all properties' do
    repo = PropertyRepository.new
    properties = repo.all
    expect(properties.length).to eq 5

    expect(properties[0].id).to eq 1
    expect(properties[0].name).to eq 'house1'
    expect(properties[0].location).to eq 'place1'
    expect(properties[0].description).to eq 'description1'
    expect(properties[0].price).to eq 9.99
    expect(properties[0].availability).to eq "t"
    expect(properties[0].user_id).to eq 1

    expect(properties[2].id).to eq 3
    expect(properties[2].name).to eq 'house3'
    expect(properties[2].location).to eq 'place3'
    expect(properties[2].description).to eq 'description3'
    expect(properties[2].price).to eq 13.99
    expect(properties[2].availability).to eq "t"
    expect(properties[2].user_id).to eq 3

    expect(properties[4].id).to eq 5
    expect(properties[4].name).to eq 'house5'
    expect(properties[4].location).to eq 'place5'
    expect(properties[4].description).to eq 'description5'
    expect(properties[4].price).to eq 15.99
    expect(properties[4].availability).to eq "t"
    expect(properties[4].user_id).to eq 1
  end

  it 'creates a new property object' do
    property = Property.new
    property.name = 'house6'
    property.location = 'place6'
    property.description = 'description6'
    property.price = 11.99
    property.availability = "t"
    property.user_id = 4

    repo = PropertyRepository.new
    repo.create(property)
    properties = repo.all
    expect(properties.last.id).to eq 6
    expect(properties.last.name).to eq 'house6'
    expect(properties.last.location).to eq 'place6'
    expect(properties.last.description).to eq 'description6'
    expect(properties.last.price).to eq 11.99
    expect(properties.last.availability).to eq "t"
    expect(properties.last.user_id).to eq 4
  end

  it 'returns all properties belonging to a specific user' do
    repo = PropertyRepository.new
    properties = repo.my_properties(1)

    expect(properties.length).to eq 2

    expect(properties[0].id).to eq 1
    expect(properties[0].name).to eq 'house1'
    expect(properties[0].location).to eq 'place1'
    expect(properties[0].description).to eq 'description1'
    expect(properties[0].price).to eq 9.99
    expect(properties[0].availability).to eq "t"
    expect(properties[0].user_id).to eq 1

    expect(properties[1].id).to eq 5
    expect(properties[1].name).to eq 'house5'
    expect(properties[1].location).to eq 'place5'
    expect(properties[1].description).to eq 'description5'
    expect(properties[1].price).to eq 15.99
    expect(properties[0].availability).to eq "t"
    expect(properties[1].user_id).to eq 1
  end

  context 'updates the property availablity' do
    it 'sets availablity to false' do
      repo = PropertyRepository.new
      repo.update_availability(5, "f")

      properties = repo.all
      expect(properties[4].id).to eq 5
      expect(properties[4].name).to eq 'house5'
      expect(properties[4].location).to eq 'place5'
      expect(properties[4].description).to eq 'description5'
      expect(properties[4].price).to eq 15.99
      expect(properties[4].availability).to eq "f"
      expect(properties[4].user_id).to eq 1
    end
  end
end
