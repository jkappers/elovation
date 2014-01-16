FactoryGirl.define do
  factory :player do
    name 		 { Faker::Name.name }
    email 	 { Faker::Internet.email }
    password "12345678"
  end
end
