require 'spec_helper'

describe LoyaltyPoint do
  it {should respond_to :id}
  it {should respond_to :description}
  it {should respond_to :previous_points}
  it {should respond_to :current_points}
  it {should respond_to :customer}
  it {should respond_to :created_at}
  it {should respond_to :updated_at}

  describe 'creating loyalty_point' do
    it 'should create a new loyalty_point with previous and current values' do
      loyalty_point = LoyaltyPoint.create previous_points: 0, current_points: 1000, description: 'oi'
      expect(loyalty_point.previous_points).to eq 0
      expect(loyalty_point.current_points).to eq 1000
      expect(loyalty_point.description).to eq 'oi'
      expect(loyalty_point.id).not_to be_nil
    end

    it 'should not create a new loyalty_point without previous and current values' do
      loyalty_point = LoyaltyPoint.new
      expect(loyalty_point.valid?).not_to be true
      expect {loyalty_point.validate!}.to raise_error Sequel::ValidationFailed
      expect(loyalty_point.errors).to include :previous_points, :current_points
    end

    it 'should not redeem more than it has' do
      loyalty_point = LoyaltyPoint.new previous_points: 0, current_points: -1000
      expect(loyalty_point.valid?).not_to be true
      expect {loyalty_point.validate!}.to raise_error Sequel::ValidationFailed
      expect(loyalty_point.errors).to include :current_points
    end

    it 'should issue some integer value' do
      loyalty_point = LoyaltyPoint.new previous_points: 0, current_points: 1000
      expect(loyalty_point.valid?).not_to be false
      expect {loyalty_point.validate!}.not_to raise_error
      expect(loyalty_point.errors).to be_empty
    end

    it 'should accept only integer values for the previous and current elements' do
      loyalty_point = LoyaltyPoint.new previous_points: '1.2', current_points: 'oi'
      expect(loyalty_point.valid?).not_to be true
      expect {loyalty_point.validate!}.to raise_error Sequel::ValidationFailed
      expect(loyalty_point.errors).to include :previous_points, :current_points
    end
  end
end
