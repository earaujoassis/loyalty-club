ENV['RACK_ENV'] = 'test'

require './app'
require 'rspec'
require 'rack/test'

describe 'LoyaltyPoints route:' do
  include Rack::Test::Methods

  def app
    Hectic::App
  end

  before :all do
    @customer = Hectic::Models::Customer.first!
  end

  it 'gets a list of transactions for a given customer' do
    get "/v1/customers/#{@customer.id}/points/"
    expect(last_response).to be_ok

  end

  it 'gets the current amount of points for a given customer' do
    get "/v1/customers/#{@customer.id}/current_points/"
    expect(last_response).to be_ok

  end

  pending 'it creates/updates data in a development database' do
    it 'creates a new transaction of loyalty points for a given customer' do
      post '/v1/customers/#{@customer.id}/points/', { balance: '+10', description: 'testing description' }
      expect(last_response).to be_ok

    end

    it 'updates a given transaction of loyalty points for a given customer' do
      put '/v1/customers/#{@customer.id}/points/:id/'
      expect(last_response).to be_ok

    end
  end
end
