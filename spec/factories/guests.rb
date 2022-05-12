FactoryBot.define do
  factory :guest do |f|
    f.first_name { Faker::Name.name }
    f.last_name { Faker::Name.name }
    f.email { Faker::Internet.email }
    f.phones { ["1234567890", "1234567891"] }
  end
end
