FactoryBot.define do
  factory :tag do
    title { Faker::Book.title }
    slug { title.parameterize(separator: '_') }
  end
end
