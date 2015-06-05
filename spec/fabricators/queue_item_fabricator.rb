Fabricator(:queue_item) do
  user
  video
  order { rand(1..10) }
end