Fabricator(:user) do
  email           { Faker::Internet.email }
  name            { Faker::Name.name }
  password        { Faker::Internet.password }
  customer_token  { "cus_" + Faker::Lorem.characters(14) }
  admin           false
  active          true
end

Fabricator(:admin, from: :user) do
  admin true
end