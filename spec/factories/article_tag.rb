FactoryBot.define do
  factory :article_tag do
    article_id { create(:article).id }
    tag_id { create(:tag).id }
  end
end
