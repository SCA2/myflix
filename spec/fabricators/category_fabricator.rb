Fabricator(:category) do
  name      { Faker::Name.name }
  videos(count: 3)
end