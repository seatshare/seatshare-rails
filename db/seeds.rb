# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Entity.create([
  {
    id: 1, entity_name: 'Nashville Predators', logo: '//upload.wikimedia.org/wikipedia/en/9/9c/Nashville_Predators_Logo_%282011%29.svg', status: 1
  },
  {
    id: 2, entity_name: 'Belmont Bruins MBB', logo: '//upload.wikimedia.org/wikipedia/en/3/3d/BelmontBruins.png', status: 1
  },
  {
    id: 3, entity_name: 'Nashville Rollergirls', logo: '//upload.wikimedia.org/wikipedia/en/d/da/Nashville_Rollergirls.gif', status: 1
  },
  {
    id: 4, entity_name: 'Tennessee Titans', logo: '//upload.wikimedia.org/wikipedia/en/c/c1/Tennessee_Titans_logo.svg', status: 1
  },
  {
    id: 5, entity_name: 'Nashville Symphony', logo: '//upload.wikimedia.org/wikipedia/en/b/b7/NashvilleSymphonyLogo.png', status: 0
  }
])

Event.create([
  {
    entity_id: 4, event_name: 'Preseason: Packers vs. Titans', description: '', start_time: '2014-08-09 19:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Preseason: Packers vs. Vikings', description: '', start_time: '2014-08-28 19:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Cowboys vs. Titans', description: 'Season Opener', start_time: '2014-09-14 12:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Brows vs. Titans', description: '', start_time: '2014-10-05 12:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Jaguars vs. Titans', description: '', start_time: '2014-10-12 12:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Texans vs. Titans', description: '', start_time: '2014-10-26 12:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Steelers vs. Titans', description: 'Monday Night Football', start_time: '2014-11-17 19:30', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Giants vs. Titans', description: '', start_time: '2014-12-07 12:00', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Jets vs. Titans', description: '', start_time: '2014-12-14 15:05', date_tba: 0, time_tba: 0
  },
  {
    entity_id: 4, event_name: 'Colts vs. Titans', description: 'Regular Season Finale', start_time: '2014-12-28 12:00', date_tba: 0, time_tba: 0
  }
]); 