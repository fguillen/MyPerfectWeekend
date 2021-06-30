FactoryBot.define do
  factory :admin_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Pass$$$!" }
  end

  factory :admin_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    admin_user
  end

  factory :front_authorization do
    provider { "google_oauth2" }
    sequence(:uid)
    front_user
  end

  factory :front_user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { "Pass$$$!" }
  end

  factory :post do
    title { Faker::Lorem.sentence(word_count: 20) }
    body { Faker::Lorem.sentence(word_count: 20) }
    front_user
  end

  factory :weekend do
    city { "Berlin" }
    body { Faker::Lorem.sentence(word_count: 20) }
  end
end
