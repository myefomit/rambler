FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    abstract { Faker::Book.title }
    content { Faker::Book.title }
    url { Faker::Internet.url }
    image_url { Faker::Internet.url }
    publish_date { Faker::Time.between(from: DateTime.now - 5, to: DateTime.now) }
  end
end
