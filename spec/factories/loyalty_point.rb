FactoryGirl.define do
  factory :loyalty_point do
    description {Faker::Lorem.sentence(3)}
    previous_points {Faker::Number.number(8)}
    current_points {Faker::Number.number(5).to_i * [1, -1].sample}
    customer {FactoryGirl.create :customer}
  end
end
