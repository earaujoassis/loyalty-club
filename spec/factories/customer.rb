FactoryGirl.define do
  factory :customer do
    full_name {"#{Faker::Name.first_name} #{Faker::Name.last_name}"}
  end
end
