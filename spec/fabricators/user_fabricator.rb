Fabricator(:user) do
  email     { Faker::Internet.email }
  name      { Faker::Name.name }
  password  { Faker::Internet.password }
  admin     false
end

Fabricator(:admin, from: :user) do
  admin true
end