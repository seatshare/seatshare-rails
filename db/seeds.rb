# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

entities = Entity.create([
  {
    entity_name: 'Nashville Predators', logo: '//upload.wikimedia.org/wikipedia/en/9/9c/Nashville_Predators_Logo_%282011%29.svg', status: 1
  },
  {
    entity_name: 'Belmont Bruins MBB', logo: '//upload.wikimedia.org/wikipedia/en/3/3d/BelmontBruins.png', status: 1
  },
  {
    entity_name: 'Nashville Rollergirls', logo: '//upload.wikimedia.org/wikipedia/en/d/da/Nashville_Rollergirls.gif', status: 1
  },
  {
    entity_name: 'Tennessee Titans', logo: '//upload.wikimedia.org/wikipedia/en/c/c1/Tennessee_Titans_logo.svg', status: 1
  },
  {
    entity_name: 'Nashville Symphony', logo: '//upload.wikimedia.org/wikipedia/en/b/b7/NashvilleSymphonyLogo.png', status: 0
  }
])