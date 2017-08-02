FactoryGirl.define do
  factory :pokemon, class: Pokemon do
    pokedex_id { Faker::Number.number(3) }
    name { Faker::Pokemon.name }
    sprite { Faker::Internet.url }
  end
end
