FactoryGirl.define do
  factory :post, class: Post do
    uuid { Faker::Number.number(10) }
    user
    comment { Faker::Lorem.sentence }
    pokemon
  end
end
