Fabricator(:category) do
  name      { Faker::Name.last_name }
end