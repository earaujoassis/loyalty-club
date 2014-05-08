ENV['RACK_ENV'] = 'test'

require './app'
require './spec/helpers'
require 'rspec'
require 'rack/test'

describe 'LoyaltyPoints route (based on data seeds):' do
  include Rack::Test::Methods
  include Hectic::TestHelpers

  def app
    Hectic::App
  end

  before :all do
    setup_db
    @customer = Hectic::Models::Customer.first!
    @transaction = Hectic::Models::LoyaltyPoint.first!
  end

  it 'gets a list of transactions for a given customer' do
    get "/v1/customers/#{@customer.id}/points/"
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body.length).to be 2
  end

  it 'gets the current amount of points for a given customer' do
    get "/v1/customers/#{@customer.id}/current_points/"
    expect(last_response).to be_ok
    body = symbolize_keys JSON.parse(last_response.body)
    expect(body[:previous_points]).to eq 10
    expect(body[:current_points]).to eq 5
  end

  it 'creates a new transaction of loyalty points for a given customer' do
    post "/v1/customers/#{@customer.id}/points/", {
      balance: '-2',
      description: 'testing description',
      previous_points: 100,
      current_points: 200
    }
    expect(last_response).to be_ok
    body = symbolize_keys JSON.parse(last_response.body)
    expect(body[:previous_points]).to eq 5
    expect(body[:current_points]).to eq 3
    expect(body[:description]).to eq 'testing description'
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

  it 'updates a given transaction of loyalty points for a given customer' do
    put "/v1/customers/#{@customer.id}/points/#{@transaction.id}/", {
      balance: '-2',
      description: 'update description',
      previous_points: 100,
      current_points: 200
    }
    expect(last_response).to be_ok
    body = symbolize_keys JSON.parse(last_response.body)
    expect(body[:previous_points]).to eq @transaction.previous_points
    expect(body[:current_points]).to eq @transaction.current_points
    expect(body[:description]).to eq 'update description'
  end

  after :all do
    teardown_db
  end
end
