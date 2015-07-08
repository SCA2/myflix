# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create!([{name: 'TV Comedies'}, {name: 'TV Dramas'}, {name: 'Reality TV'}])

Video.create!([
  { title: 'Family Guy', 
    description: 'Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family. Endearingly ignorant Peter and his stay-at-home wife Lois reside in Quahog, R.I., and have three kids. Meg, the eldest child, is a social outcast, and teenage Chris is awkward and clueless when it comes to the opposite sex. The youngest, Stewie, is a genius baby bent on killing his mother and destroying the world. The talking dog, Brian, keeps Stewie in check while sipping martinis and sorting through his own life issues.', 
    small_cover_url: 'family_guy.jpg', 
    large_cover_url: 'family_guy.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'Futurama', 
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.', 
    small_cover_url: 'futurama.jpg', 
    large_cover_url: 'futurama.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'Monk', 
    description: "Adrian Monk was once a rising star with the San Francisco Police Department, legendary for using unconventional means to solve the department's most baffling cases. But after the tragic (and still unsolved) murder of his wife Trudy, Monk developed an extreme case of obsessive-compulsive disorder.  Now consumed by peculiar obsessions and wracked with hundreds of phobias (including but certainly not limited to germs, heights, and even milk), Monk has lost his badge and struggles with even the simplest everyday tasks.", 
    small_cover_url: 'monk.jpg', 
    large_cover_url: 'monk_large.jpg',
    category_id: Category.where(name: 'TV Dramas')[0][:id]
  },
  { title: 'South Park', 
    description: 'The animated series is not for children. In fact, its goal seems to be to offend as many as possible as it presents the adventures of Stan, Kyle, Kenny and Cartman. The show has taken on Saddam Hussein, Osama bin Laden, politicians of every stripe and self-important celebrities. Oh, and Kenny is killed in many episodes.', 
    small_cover_url: 'south_park.jpg', 
    large_cover_url: 'south_park.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'American Dad', 
    description: 'Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family. Endearingly ignorant Peter and his stay-at-home wife Lois reside in Quahog, R.I., and have three kids. Meg, the eldest child, is a social outcast, and teenage Chris is awkward and clueless when it comes to the opposite sex. The youngest, Stewie, is a genius baby bent on killing his mother and destroying the world. The talking dog, Brian, keeps Stewie in check while sipping martinis and sorting through his own life issues.', 
    small_cover_url: 'family_guy.jpg', 
    large_cover_url: 'family_guy.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'The Simpsons', 
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.', 
    small_cover_url: 'futurama.jpg', 
    large_cover_url: 'futurama.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'The Good Wife', 
    description: "Adrian Monk was once a rising star with the San Francisco Police Department, legendary for using unconventional means to solve the department's most baffling cases. But after the tragic (and still unsolved) murder of his wife Trudy, Monk developed an extreme case of obsessive-compulsive disorder.  Now consumed by peculiar obsessions and wracked with hundreds of phobias (including but certainly not limited to germs, heights, and even milk), Monk has lost his badge and struggles with even the simplest everyday tasks.", 
    small_cover_url: 'monk.jpg', 
    large_cover_url: 'monk_large.jpg',
    category_id: Category.where(name: 'TV Dramas')[0][:id]
  },
  { title: 'Archer', 
    description: 'The animated series is not for children. In fact, its goal seems to be to offend as many as possible as it presents the adventures of Stan, Kyle, Kenny and Cartman. The show has taken on Saddam Hussein, Osama bin Laden, politicians of every stripe and self-important celebrities. Oh, and Kenny is killed in many episodes.', 
    small_cover_url: 'south_park.jpg', 
    large_cover_url: 'south_park.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'Modern Family', 
    description: 'Sick, twisted and politically incorrect, the animated series features the adventures of the Griffin family. Endearingly ignorant Peter and his stay-at-home wife Lois reside in Quahog, R.I., and have three kids. Meg, the eldest child, is a social outcast, and teenage Chris is awkward and clueless when it comes to the opposite sex. The youngest, Stewie, is a genius baby bent on killing his mother and destroying the world. The talking dog, Brian, keeps Stewie in check while sipping martinis and sorting through his own life issues.', 
    small_cover_url: 'family_guy.jpg', 
    large_cover_url: 'family_guy.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'Aqua Teen Hunger Force', 
    description: 'Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.', 
    small_cover_url: 'futurama.jpg', 
    large_cover_url: 'futurama.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  },
  { title: 'House of Cards', 
    description: "Adrian Monk was once a rising star with the San Francisco Police Department, legendary for using unconventional means to solve the department's most baffling cases. But after the tragic (and still unsolved) murder of his wife Trudy, Monk developed an extreme case of obsessive-compulsive disorder.  Now consumed by peculiar obsessions and wracked with hundreds of phobias (including but certainly not limited to germs, heights, and even milk), Monk has lost his badge and struggles with even the simplest everyday tasks.", 
    small_cover_url: 'monk.jpg', 
    large_cover_url: 'monk_large.jpg',
    category_id: Category.where(name: 'TV Dramas')[0][:id]
  },
  { title: 'The Daily Show', 
    description: 'The animated series is not for children. In fact, its goal seems to be to offend as many as possible as it presents the adventures of Stan, Kyle, Kenny and Cartman. The show has taken on Saddam Hussein, Osama bin Laden, politicians of every stripe and self-important celebrities. Oh, and Kenny is killed in many episodes.', 
    small_cover_url: 'south_park.jpg', 
    large_cover_url: 'south_park.jpg',
    category_id: Category.where(name: 'TV Comedies')[0][:id]
  }
])

tester_1 = User.create!(email: 'tester_1@example.com', name: 'Alice Tester', password: 'password')
tester_2 = User.create!(email: 'tester_2@example.com', name: 'Bob Tester', password: 'password')
tester_3 = User.create!(email: 'tester_3@example.com', name: 'Carl Tester', password: 'password')
tester_4 = User.create!(email: 'tester_4@example.com', name: 'Diane Tester', password: 'password')
tester_5 = User.create!(email: 'tester_5@example.com', name: 'Eric Tester', password: 'password')

Review.create!(user: tester_1, video: Video.first, rating: 1, body: "This is a terrible movie." )
Review.create!(user: tester_1, video: Video.first, rating: 5, body: "This is an excellent movie." )
Review.create!(user: tester_2, video: Video.second, rating: 1, body: "This is a terrible movie." )
Review.create!(user: tester_2, video: Video.second, rating: 5, body: "This is an excellent movie." )
Review.create!(user: tester_3, video: Video.third, rating: 1, body: "This is a terrible movie." )
Review.create!(user: tester_3, video: Video.third, rating: 5, body: "This is an excellent movie." )
Review.create!(user: tester_4, video: Video.fourth, rating: 1, body: "This is a terrible movie." )
Review.create!(user: tester_4, video: Video.fourth, rating: 5, body: "This is an excellent movie." )
Review.create!(user: tester_5, video: Video.fifth, rating: 1, body: "This is a terrible movie." )
Review.create!(user: tester_5, video: Video.fifth, rating: 5, body: "This is an excellent movie." )
