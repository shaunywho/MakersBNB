require 'request_repository'
require 'database_connection'

def reset_tables
    seed_sql = File.read('seeds/makers_bnb_seeds.sql')
    DatabaseConnection.exec(seed_sql)
end
  
describe RequestsRepository do
    before(:each) do 
        reset_tables
    end

    context "all function" do
        it "returns the first item from the db" do
            repo = RequestsRepository.new
            all_requests = repo.all
            expect(all_requests.length).to eq 4
            expect(all_requests[0].id).to eq "1"
            expect(all_requests[0].booker_id).to eq "1"
            expect(all_requests[0].lister_id).to eq "2"
            expect(all_requests[0].property_id).to eq "2"
            expect(all_requests[0].date).to eq '2011-12-05'
            expect(all_requests[0].confirmed).to eq "2"
        end

        it "returns the first item from the db" do
            repo = RequestsRepository.new
            all_requests = repo.all
            expect(all_requests[2].id).to eq "3"
            expect(all_requests[2].booker_id).to eq "1"
            expect(all_requests[2].lister_id).to eq "3"
            expect(all_requests[2].property_id).to eq "3"
            expect(all_requests[2].date).to eq '2011-11-05'
            expect(all_requests[2].confirmed).to eq '2'
        end
    end

    context "request function" do
        it "returns request with id 2" do
            repo = RequestsRepository.new
            request = repo.find_request(2)
            expect(request.id).to eq "2"
            expect(request.booker_id).to eq "1"
            expect(request.lister_id).to eq "3"
            expect(request.property_id).to eq "3"
            expect(request.date).to eq '2011-11-05'
            expect(request.confirmed).to eq "2"
        end

        it "returns request with id 4" do
            repo = RequestsRepository.new
            request = repo.find_request(4)
            expect(request.id).to eq "4"
            expect(request.booker_id).to eq "1"
            expect(request.lister_id).to eq "4"
            expect(request.property_id).to eq "4"
            expect(request.date).to eq '2011-12-05'
            expect(request.confirmed).to eq "2"
        end

        it "returns nil if no such request is present in db" do
            repo = RequestsRepository.new
            request = repo.find_request(5)
            expect(request).to eq nil
        end
    end

    context "create request function" do
        it "creates a new request" do
            repo = RequestsRepository.new
            request = Request.new
            request.booker_id = 1
            request.lister_id = 3
            request.property_id = 5
            request.date = "2011-11-06"
            request.confirmed = 1
            repo.create_request(request.booker_id, request.lister_id, request.property_id, request.date, request.confirmed)
            last_request = repo.all.last

            expect(last_request.booker_id).to eq "1"
            expect(last_request.lister_id).to eq "3"
            expect(last_request.property_id).to eq "5"
            expect(last_request.date).to eq "2011-11-06"
            expect(last_request.confirmed).to eq "1"
        end
    end

    context "requests for me method" do
        it "returns the requests for lister 3" do
            repo = RequestsRepository.new
            requests = repo.requests_for_me(3)
            expect(requests.length).to eq 2
            expect(requests[0].id).to eq '2'
            expect(requests[0].booker_name).to eq "Shaun"
            expect(requests[0].booker_email).to eq "shaunho@gmail.com"
            expect(requests[0].property).to eq "house3"
            expect(requests[0].price).to eq "13.99"
            expect(requests[0].date).to eq "2011-11-05"
            expect(requests[0].confirmed).to eq "2"

        end

        it "returns nil if the lister doesn't exist" do
            repo = RequestsRepository.new
            requests = repo.requests_for_me(6)
            expect(requests).to eq nil

        end
    end

    context "requests from me function" do
        it "retunrs listings for booker 1" do
            repo = RequestsRepository.new

            all_requests = repo.requests_from_me(1)
            expect(all_requests[0].id).to eq "1"
            expect(all_requests[0].property).to eq "house2"
            expect(all_requests[0].location).to eq "place2"
            expect(all_requests[0].description).to eq "description2"
            expect(all_requests[0].price).to eq "12.99"
            expect(all_requests[0].date).to eq "2011-12-05"
            expect(all_requests[0].confirmed).to eq "2"

        end

        it "returns nil for a booker that doesn't exist" do
            repo = RequestsRepository.new

            all_requests = repo.requests_for_me(10)
            expect(all_requests).to eq nil
        end
    end

    context "confirm request method" do
        it "changes the confirmed from 0 to 1" do
            repo = RequestsRepository.new
            repo.confirm_request(2,1)
            request = repo.find_request(2)
            expect(request.confirmed).to eq "1"
        end
    end

end