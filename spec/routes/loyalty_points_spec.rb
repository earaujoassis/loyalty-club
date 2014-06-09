require 'spec_helper'

describe Hectic::Routes::LoyaltyPoints do
  include Rack::Test::Methods

  let(:app) do
    Hectic::App
  end

  let(:fake_id) do
    UUID.new.generate
  end

  before do
    @customer = FactoryGirl.create :customer
    first = LoyaltyPoint.create previous_points: 0, current_points: Faker::Number.number(8), \
      customer: @customer
    @transaction = LoyaltyPoint.create previous_points: first.current_points, \
      current_points: first.current_points + 1000, customer: @customer
  end

  describe 'listing and getting transactions' do
    it 'should get a list of transactions for a given customer' do
      get "/v1/customers/#{@customer.id}/points/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body.length).to be > 1
    end

    it 'should try to get a list of transactions for an absent customer and fail' do
      get "/v1/customers/#{fake_id}/points/"
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to get a list of transactions with a malformed customer\'s ID and fail'  do
      get "/v1/customers/0/points/"
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end

    it 'should get the latest transaction of points for a given customer' do
      latest = LoyaltyPoint.filter(customer: @customer).order(:created_at.desc).first
      previous_points = latest.previous_points
      current_points = latest.current_points
      get "/v1/customers/#{@customer.id}/points/latest/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body.keys).to include :id, :previous_points, :current_points, :description
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
    end

    it 'should try to get the latest transaction of points for an absent customer and fail' do
      get "/v1/customers/#{fake_id}/points/latest/"
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to get the latest transaction of points with a malformed customer\'s ID and fail' do
      get "/v1/customers/0/points/latest/"
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end
  end

  describe 'creating transactions' do
    it 'should create a new transaction of loyalty points for a given customer' do
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
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body.keys).to include :id, :previous_points, :current_points, :description
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body[:description]).to eq 'testing description'
    end

    it 'should try to create a new transaction of loyalty points for an absent customer and fail' do
      post "/v1/customers/#{fake_id}/points/", { balance: '-2', description: 'testing description' }
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to create a new transaction of loyalty points with a malformed customer\'s ID and fail' do
      post "/v1/customers/0/points/", { balance: '-2', description: 'testing description' }
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end

    it 'should try to redeem more points than the customer has in its current balance and fail' do
      post "/v1/customers/#{@customer.id}/points/", {
        balance: '-9999999999',
        description: 'testing description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 406
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'validation_failed'
    end

    it 'should create a new transaction of loyalty points, w/o a description, for a given customer' do
      amount = 1000
      previous_points = LoyaltyPoint.filter(customer: @customer).order(:created_at.desc).first.current_points # from future
      current_points = previous_points + amount # from future
      post "/v1/customers/#{@customer.id}/points/", {
        balance: "+#{amount}",
        previous_points: 100,
        current_points: 200
      }
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body.keys).to include :id, :previous_points, :current_points, :description
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body[:description]).to eq ''
    end
  end

  describe 'updating a transaction' do
    it 'should update a given transaction of loyalty points for a given customer' do
      previous_points = @transaction.previous_points
      current_points = @transaction.current_points
      put "/v1/customers/#{@customer.id}/points/#{@transaction.id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body.keys).to include :id, :previous_points, :current_points, :description
      expect(body[:previous_points]).to eq previous_points
      expect(body[:current_points]).to eq current_points
      expect(body[:description]).to eq 'update description'
    end

    it 'should try to update a given transaction of loyalty points for an absent customer and fail' do
      put "/v1/customers/#{fake_id}/points/#{@transaction.id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to update a given transaction of loyalty points with a malformed customer\'s ID and fail' do
      put "/v1/customers/0/points/#{@transaction.id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end

    it 'should try to update an absent transaction of loyalty points for a valid customer and fail' do
      put "/v1/customers/#{@customer.id}/points/#{fake_id}/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to update a transaction of loyalty points with a malformed ID for a valid customer and fail' do
      put "/v1/customers/#{@customer.id}/points/0/", {
        balance: '-2',
        description: 'update description',
        previous_points: 100,
        current_points: 200
      }
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end
  end
end
