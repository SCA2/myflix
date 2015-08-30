Fabricator(:payment) do
  user
  amount        { Faker::Commerce.price }
  reference_id  { "ch_" + Faker::Lorem.characters(14) }
end