Fabricator(:review) do
  user
  video
  body    { Faker::Lorem.paragraph }
  rating  { rand(1..5) }
end