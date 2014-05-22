ENV['RACK_ENV'] = 'test'

require './app'
require './spec/helpers'
require 'rspec'
require 'rack/test'
require 'uuid'

describe 'LoyaltyPoints route (based on data seeds):' do
  include Rack::Test::Methods
  include Hectic::TestHelpers

  def app
    Hectic::App
  end

  before :each do
    setup_db
    @customer = Hectic::Models::Customer.first!
    @absent_customer = UUID.new.generate
    @transaction = Hectic::Models::LoyaltyPoint.first!
    @absent_transaction = UUID.new.generate
  end

  context 'get: list of transactions:' do
    it 'gets a list of transactions for a given customer' do
      get "/v1/customers/#{@customer.id}/points/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body.length).to be 2
    end

    it 'tries to get a list of transactions for an absent customer' do
      get "/v1/customers/#{@absent_customer}/points/"
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to get a list of transactions with a malformed customer\'s ID'  do
      get "/v1/customers/0/points/"
      expect(last_response.status).to eq 500
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'database_error'
    end
  end

  context 'get: latest transaction:' do
    it 'gets the latest transaction of points for a given customer' do
      previous_points = @customer.loyalty_points[-1].previous_points
      current_points = @customer.loyalty_points[-1].current_points
      get "/v1/customers/#{@customer.id}/points/latest/"
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body.keys).to include(:id)
    end

    it 'tries to get the latest transaction of points for an absent customer' do
      get "/v1/customers/#{@absent_customer}/points/latest/"
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to get the latest transaction of points with a malformed customer\'s ID' do
      get "/v1/customers/0/points/latest/"
      expect(last_response.status).to eq 500
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'database_error'
    end
  end

  context 'post: transactions creation:' do
    it 'creates a new transaction of loyalty points for a given customer' do
      amount = -2
      previous_points = @customer.loyalty_points[-1].current_points # from future
      current_points = previous_points + amount # from future
      post "/v1/customers/#{@customer.id}/points/", {
        balance: "#{amount}",
        description: 'testing description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body[:description]).to eq 'testing description'
      expect(body.keys).to include(:id)
    end

    it 'tries to create a new transaction of loyalty points for an absent customer' do
      post "/v1/customers/#{@absent_customer}/points/", {
        balance: '-2',
        description: 'testing description'
      }
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to create a new transaction of loyalty points with a malformed customer\'s ID' do
      post "/v1/customers/0/points/", {
        balance: '-2',
        description: 'testing description'
      }
      expect(last_response.status).to eq 500
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'database_error'
    end

    it 'tries to redeem more points than the customer has in its current balance' do
      post "/v1/customers/#{@customer.id}/points/", {
        balance: '-1000',
        description: 'testing description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 406
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'validation_failed'
    end

    it 'creates a new transaction of loyalty points, w/o a description, for a given customer' do
      amount = 1000
      previous_points = @customer.loyalty_points[-1].current_points # from future
      current_points = previous_points + amount # from future
      post "/v1/customers/#{@customer.id}/points/", {
        balance: "+#{amount}",
        previous_points: 100,
        current_points: 200
      }
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body[:description]).to eq ''
      expect(body.keys).to include(:id)
    end
  end

  context 'put: updates a transaction' do
    it 'updates a given transaction of loyalty points for a given customer' do
      previous_points = @transaction.previous_points
      current_points = @transaction.current_points
      put "/v1/customers/#{@customer.id}/points/#{@transaction.id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response).to be_ok
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body[:description]).to eq 'update description'
      expect(body.keys).to include(:id)
    end

    it 'tries to update a given transaction of loyalty points for an absent customer' do
      put "/v1/customers/#{@absent_customer}/points/#{@transaction.id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to update a given transaction of loyalty points with a malformed customer\'s ID' do
      put "/v1/customers/0/points/#{@transaction.id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 500
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'database_error'
    end

    it 'tries to update an absent transaction of loyalty points for a valid customer' do
      put "/v1/customers/#{@customer.id}/points/#{@absent_transaction}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 404
      body = symbolize_keys JSON.parse(last_response.body)
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'tries to update a transaction of loyalty points with a malformed ID for a valid customer' do
      put "/v1/customers/#{@customer.id}/points/0/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
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
