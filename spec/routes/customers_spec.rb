ENV['RACK_ENV'] = 'test'

require './app'
require './spec/helpers'
require 'rspec'
require 'rack/test'
require 'uuid'

describe 'Customers route (based on data seeds):' do
  include Rack::Test::Methods
  include Hectic::TestHelpers

  def app
    Hectic::App
  end

  before :each do
    setup_db
    @customer = Hectic::Models::Customer.first!
    @absent_customer = UUID.new.generate
  end

  context 'get: list of customers:' do
    it 'gets a list of customers' do
      get "/v1/customers/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body.length).to be 5
    end
  end

  context 'get: a customer:' do
    it 'gets a given customer' do
      get "/v1/customers/#{@customer.id}/"
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body.keys).to include(:id)
      expect(body[:full_name]).to eq @customer.full_name
      expect(body[:id]).to eq @customer.id
    end

    it 'tries to get an absent customer' do
      get "/v1/customers/#{@absent_customer}/"
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to get a malformed customer\'s ID'  do
      get "/v1/customers/0/"
      expect(last_response.status).to eq 500
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'database_error'
    end
  end

  context 'post: customer creation:' do
    it 'creates a new customer' do
      post "/v1/customers/", {
        full_name: "Robot RSpec"
      }
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:full_name]).to eq 'Robot RSpec'
      expect(body.keys).to include(:id)
    end

    it 'tries to create a new customer w/o any data' do
      post "/v1/customers/", {}
      expect(last_response.status).to eq 406
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'validation_failed'
    end
  end

  context 'put: updates a customer:' do
    it 'updates a given customer\'s full name' do
      put "/v1/customers/#{@customer.id}/", {
        full_name: "Robot R2"
      }
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:full_name]).to eq 'Robot R2'
    end

    it 'tries to update an absent customer' do
      put "/v1/customers/#{@absent_customer}/", {
        full_name: "Mr Absent"
      }
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to update a customer with a malformed ID' do
      put "/v1/customers/0/", {
        full_name: "Mr Absent"
      }
      expect(last_response.status).to eq 500
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'database_error'
    end
  end

  after :each do
    teardown_db
  end
end
