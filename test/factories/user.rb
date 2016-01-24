FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    confirmed 1
    sleeping 0
    nickname Faker::Name.first_name
    company Faker::Company.name
    occupation Faker::Name.title
    phone Faker::PhoneNumber.phone_number
    city Faker::Address.city
  end
end
