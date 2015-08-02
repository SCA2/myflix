Fabricator(:video) do
  title       { Faker::Lorem.words(3).join(' ') }
  description { Faker::Lorem.paragraph }
  small_cover { Faker::Internet.url }
  large_cover { Faker::Internet.url }
  category
end