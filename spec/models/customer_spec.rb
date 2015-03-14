require 'spec_helper'

describe Customer do
  it {should respond_to :id}
  it {should respond_to :full_name}
  it {should respond_to :loyalty_points}
  it {should respond_to :created_at}
  it {should respond_to :updated_at}

  describe 'creating customers' do
    it 'should create a new customer with an unique name' do
      customer = Customer.new(full_name: 'It Works').save
      expect(customer.full_name).to eq 'It Works'
      expect(customer.id).not_to be_nil
    end

    it 'should not create a new customer without a name' do
      customer = Customer.new
      expect(customer.valid?).not_to be true
      expect {customer.validate!}.to raise_error Sequel::ValidationFailed
      expect(customer.errors).to include :full_name
    end

    it 'should not create customers with the same name' do
      Customer.create full_name: 'Same Name'
      customer = Customer.new full_name: 'Same Name'
      expect(customer.valid?).not_to be true
      expect {customer.validate!}.to raise_error Sequel::ValidationFailed
      expect(customer.errors).to include :full_name
    end
  end
end
