Fabricator(:invitation) do
  email     { Faker::Internet.email }
  name      { Faker::Name.name }
  message   { Faker::Lorem.sentences.join(' ') }
end