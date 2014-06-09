require 'spec_helper'

describe Hectic::Routes::Customers do
  include Rack::Test::Methods

  let(:app) do
    Hectic::App
  end

  let(:customer) do
    FactoryGirl.create :customer
  end

  let(:fake_id) do
    UUID.new.generate
  end

  let(:fake_name) do
    "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  end

  describe 'listing and getting customers' do
    before do
      FactoryGirl.create :customer
      FactoryGirl.create :customer
    end

    it 'should get a list of (at least two) customers' do
      get "/v1/customers/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body)
      expect(body.length).to be > 1
    end

    it 'should get a given customer' do
      subject = customer
      get "/v1/customers/#{subject.id}/"
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body.keys).to include(:id)
      expect(body[:full_name]).to eq subject.full_name
      expect(body[:id]).to eq subject.id
    end

    it 'should try to get an absent customer and fail' do
      get "/v1/customers/#{fake_id}/"
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to get a malformed customer\'s ID and fail'  do
      get "/v1/customers/0/"
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end
  end

  context 'creating a customer' do
    it 'should create a new customer' do
      name = fake_name
      post "/v1/customers/", { full_name: name }
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:full_name]).to eq name
      expect(body.keys).to include :id
    end

    it 'should try to create a new customer w/o any data and fail' do
      post "/v1/customers/", { }
      expect(last_response.status).to eq 406
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'validation_failed'
    end
  end

  context 'updating a customer' do
    it 'should update a given customer\'s full name' do
      subject = customer
      name = fake_name
      put "/v1/customers/#{subject.id}/", { full_name: name }
      expect(last_response).to be_ok
      body = JSON.parse(last_response.body).symbolize_keys!
      subject.reload
      expect(body[:id]).to eq subject.id
      expect(body[:full_name]).to eq name
    end

    it 'should try to update an absent customer and fail' do
      put "/v1/customers/#{fake_id}/", { full_name: fake_name }
      expect(last_response.status).to eq 404
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'unknown_record'
    end

    it 'should try to update a customer with a malformed ID and fail' do
      put "/v1/customers/0/", { full_name: fake_name }
      expect(last_response.status).to eq 500
      body = JSON.parse(last_response.body).symbolize_keys!
      expect(body[:error][:type]).to eq 'database_error'
    end
  end
end
