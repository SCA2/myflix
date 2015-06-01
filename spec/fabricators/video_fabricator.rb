Fabricator(:video) do
  title           { Faker::Lorem.words(3).join(' ') }
  description     { Faker::Lorem.paragraph }
  small_cover_url { Faker::Internet.url }
  large_cover_url { Faker::Internet.url }
end