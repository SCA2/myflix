# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create!([
  { title: 'Family Guy', 
    description: 'Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family. Endearingly ignorant Peter and his stay-at-home wife Lois reside in Quahog, R.I., and have three kids. Meg, the eldest child, is a social outcast, and teenage Chris is awkward and clueless when it comes to the opposite sex. The youngest, Stewie, is a genius baby bent on killing his mother and destroying the world. The talking dog, Brian, keeps Stewie in check while sipping martinis and sorting through his own life issues.', 
    small_cover_url: 'family_guy.jpg', 
    large_cover_url: 'family_guy.jpg'
  },
  { title: 'Futurama', 
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.', 
    small_cover_url: 'futurama.jpg', 
    large_cover_url: 'futurama.jpg'
  },
  { title: 'Monk', 
    description: "Adrian Monk was once a rising star with the San Francisco Police Department, legendary for using unconventional means to solve the department's most baffling cases. But after the tragic (and still unsolved) murder of his wife Trudy, Monk developed an extreme case of obsessive-compulsive disorder.  Now consumed by peculiar obsessions and wracked with hundreds of phobias (including but certainly not limited to germs, heights, and even milk), Monk has lost his badge and struggles with even the simplest everyday tasks.", 
    small_cover_url: 'monk.jpg', 
    large_cover_url: 'monk_large.jpg'
  },
  { title: 'South Park', 
    description: 'The animated series is not for children. In fact, its goal seems to be to offend as many as possible as it presents the adventures of Stan, Kyle, Kenny and Cartman. The show has taken on Saddam Hussein, Osama bin Laden, politicians of every stripe and self-important celebrities. Oh, and Kenny is killed in many episodes.', 
    small_cover_url: 'south_park.jpg', 
    large_cover_url: 'south_park.jpg'
  }
])
