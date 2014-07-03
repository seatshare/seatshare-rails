# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Entity.create([
  {
    id: 101, entity_name: 'Anaheim Ducks', import_key: 'Anaheim', entity_type: 'NHL', status: 1
  },
  {
    id: 102, entity_name: 'Arizona Coyotes', import_key: 'Arizona', entity_type: 'NHL', status: 1
  },
  {
    id: 103, entity_name: 'Boston Bruins', import_key: 'Boston', entity_type: 'NHL', status: 1
  },
  {
    id: 104, entity_name: 'Buffalo Sabres', import_key: 'Buffalo', entity_type: 'NHL', status: 1
  },
  {
    id: 105, entity_name: 'Calgary Flames', import_key: 'Calgary', entity_type: 'NHL', status: 1
  },
  {
    id: 106, entity_name: 'Carolina Hurricanes', import_key: 'Carolina', entity_type: 'NHL', status: 1
  },
  {
    id: 107, entity_name: 'Chicago Blackhawks', import_key: 'Chicago', entity_type: 'NHL', status: 1
  },
  {
    id: 108, entity_name: 'Columbus Blue Jackets', import_key: 'Columbus', entity_type: 'NHL', status: 1
  },
  {
    id: 109, entity_name: 'Colorado Avalanche', import_key: 'Colorado', entity_type: 'NHL', status: 1
  },
  {
    id: 110, entity_name: 'Dallas Stars', import_key: 'Dallas', entity_type: 'NHL', status: 1
  },
  {
    id: 111, entity_name: 'Detroit Red Wings', import_key: 'Detroit', entity_type: 'NHL', status: 1
  },
  {
    id: 112, entity_name: 'Edmonton Oilers', import_key: 'Edmonton', entity_type: 'NHL', status: 1
  },
  {
    id: 113, entity_name: 'Florida Panthers', import_key: 'Florida', entity_type: 'NHL', status: 1
  },
  {
    id: 114, entity_name: 'Los Angeles Kings', import_key: 'Los Angeles', entity_type: 'NHL', status: 1
  },
  {
    id: 115, entity_name: 'Minnesota Wild', import_key: 'Minnesota', entity_type: 'NHL', status: 1
  },
  {
    id: 116, entity_name: 'Montréal Canadiens', import_key: 'Montréal', entity_type: 'NHL', status: 1
  },
  {
    id: 117, entity_name: 'Nashville Predators', import_key: 'Nashville', entity_type: 'NHL', status: 1
  },
  {
    id: 118, entity_name: 'New Jersey Devils', import_key: 'New Jersey', entity_type: 'NHL', status: 1
  },
  {
    id: 119, entity_name: 'New York Islanders', import_key: 'NY Islanders', entity_type: 'NHL', status: 1
  },
  {
    id: 120, entity_name: 'New York Rangers', import_key: 'NY Rangers', entity_type: 'NHL', status: 1
  },
  {
    id: 121, entity_name: 'Ottawa Senators', import_key: 'Ottawa', entity_type: 'NHL', status: 1
  },
  {
    id: 122, entity_name: 'Philadelphia Flyers', import_key: 'Philadelphia', entity_type: 'NHL', status: 1
  },
  {
    id: 123, entity_name: 'Pittsburgh Penguins', import_key: 'Pittsburgh', entity_type: 'NHL', status: 1
  },
  {
    id: 124, entity_name: 'San Jose Sharks', import_key: 'San Jose', entity_type: 'NHL', status: 1
  },
  {
    id: 125, entity_name: 'St. Louis Blues', import_key: 'St. Louis', entity_type: 'NHL', status: 1
  },
  {
    id: 126, entity_name: 'Tampa Bay Lightning', import_key: 'Tampa Bay', entity_type: 'NHL', status: 1
  },
  {
    id: 127, entity_name: 'Toronto Maple Leafs', import_key: 'Toronto', entity_type: 'NHL', status: 1
  },
  {
    id: 128, entity_name: 'Vancouver Canucks', import_key: 'Vancouver', entity_type: 'NHL', status: 1
  },
  {
    id: 129, entity_name: 'Washington Capitals', import_key: 'Washington', entity_type: 'NHL', status: 1
  },
  {
    id: 130, entity_name: 'Winnipeg Jets', import_key: 'Winnipeg', entity_type: 'NHL', status: 1
  },
  {
    id: 201, entity_name: 'Anaheim Angels', import_key: 'Anaheim', entity_type: 'MLB', status: 1
  },
  {
    id: 202, entity_name: 'Arizona Diamondbacks', import_key: 'Arizona', entity_type: 'MLB', status: 1
  },
  {
    id: 203, entity_name: 'Atlanta Braves', import_key: 'Atlanta', entity_type: 'MLB', status: 1
  },
  {
    id: 204, entity_name: 'Baltimore Orioles', import_key: 'Baltimore', entity_type: 'MLB', status: 1
  },
  {
    id: 205, entity_name: 'Boston Red Sox', import_key: 'Boston', entity_type: 'MLB', status: 1
  },
  {
    id: 206, entity_name: 'Chicago Cubs', import_key: 'Chicago Cubs', entity_type: 'MLB', status: 1
  },
  {
    id: 207, entity_name: 'Chicago White Sox', import_key: 'Chicago White Sox', entity_type: 'MLB', status: 1
  },
  {
    id: 208, entity_name: 'Cincinnati Reds', import_key: 'Cincinnati', entity_type: 'MLB', status: 1
  },
  {
    id: 209, entity_name: 'Cleveland Indians', import_key: 'Cleveland', entity_type: 'MLB', status: 1
  },
  {
    id: 210, entity_name: 'Colorado Rockies', import_key: 'Colorado', entity_type: 'MLB', status: 1
  },
  {
    id: 211, entity_name: 'Detroit Tigers', import_key: 'Detroit', entity_type: 'MLB', status: 1
  },
  {
    id: 212, entity_name: 'Houston Astros', import_key: 'Houston', entity_type: 'MLB', status: 1
  },
  {
    id: 213, entity_name: 'Kansas City Royals', import_key: 'Kansas City', entity_type: 'MLB', status: 1
  },
  {
    id: 214, entity_name: 'Los Angeles Dodgers', import_key: 'Los Angeles', entity_type: 'MLB', status: 1
  },
  {
    id: 215, entity_name: 'Miami Marlins', import_key: 'Miami', entity_type: 'MLB', status: 1
  },
  {
    id: 216, entity_name: 'Milwaukee Brewers', import_key: 'Milwaukee', entity_type: 'MLB', status: 1
  },
  {
    id: 217, entity_name: 'Minnesota Twins', import_key: 'Minnesota', entity_type: 'MLB', status: 1
  },
  {
    id: 218, entity_name: 'New York Mets', import_key: 'NY Mets', entity_type: 'MLB', status: 1
  },
  {
    id: 219, entity_name: 'New York Yankees', import_key: 'NY Yankees', entity_type: 'MLB', status: 1
  },
  {
    id: 220, entity_name: 'Oakland Athletics', import_key: 'Oakland', entity_type: 'MLB', status: 1
  },
  {
    id: 221, entity_name: 'Philadelphia Phillies', import_key: 'Philadelphia', entity_type: 'MLB', status: 1
  },
  {
    id: 222, entity_name: 'Pittsburgh Pirates', import_key: 'Pittsburgh', entity_type: 'MLB', status: 1
  },
  {
    id: 223, entity_name: 'San Diego Padres', import_key: 'San Diego', entity_type: 'MLB', status: 1
  },
  {
    id: 224, entity_name: 'San Francisco Giants', import_key: 'San Francisco', entity_type: 'MLB', status: 1
  },
  {
    id: 225, entity_name: 'Seattle Mariners', import_key: 'Seattle', entity_type: 'MLB', status: 1
  },
  {
    id: 226, entity_name: 'St. Louis Cardinals', import_key: 'St. Louis', entity_type: 'MLB', status: 1
  },
  {
    id: 227, entity_name: 'Tampa Bay Rays', import_key: 'Tampa Bay', entity_type: 'MLB', status: 1
  },
  {
    id: 228, entity_name: 'Texas Rangers', import_key: 'Texas', entity_type: 'MLB', status: 1
  },
  {
    id: 229, entity_name: 'Toronto Blue Jays', import_key: 'Toronto', entity_type: 'MLB', status: 1
  },
  {
    id: 230, entity_name: 'Washington Nationals', import_key: 'Washington', entity_type: 'MLB', status: 1
  },
  {
    id: 301, entity_name: 'Atlanta Hawks', import_key: 'Atlanta', entity_type: 'NBA', status: 1
  },
  {
    id: 302, entity_name: 'Boston Celtics', import_key: 'Boston', entity_type: 'NBA', status: 1
  },
  {
    id: 303, entity_name: 'Brooklyn Nets', import_key: 'Brooklyn', entity_type: 'NBA', status: 1
  },
  {
    id: 304, entity_name: 'Charlotte Hornets', import_key: 'Charlotte', entity_type: 'NBA', status: 1
  },
  {
    id: 305, entity_name: 'Chicago Bulls', import_key: 'Chicago', entity_type: 'NBA', status: 1
  },
  {
    id: 306, entity_name: 'Cleveland Cavaliers', import_key: 'Cleveland', entity_type: 'NBA', status: 1
  },
  {
    id: 307, entity_name: 'Dallas Mavericks', import_key: 'Dallas', entity_type: 'NBA', status: 1
  },
  {
    id: 308, entity_name: 'Denver Nuggets', import_key: 'Denver', entity_type: 'NBA', status: 1
  },
  {
    id: 309, entity_name: 'Detroit Pistons', import_key: 'Detroit', entity_type: 'NBA', status: 1
  },
  {
    id: 310, entity_name: 'Golden State Warriors', import_key: 'Golden', entity_type: 'NBA', status: 1
  },
  {
    id: 311, entity_name: 'Houston Rockets', import_key: 'Houston', entity_type: 'NBA', status: 1
  },
  {
    id: 312, entity_name: 'Indiana Pacers', import_key: 'Indiana', entity_type: 'NBA', status: 1
  },
  {
    id: 313, entity_name: 'Los Angeles Clippers', import_key: 'LA Clippers', entity_type: 'NBA', status: 1
  },
  {
    id: 314, entity_name: 'Los Angeles Lakers', import_key: 'LA Lakers', entity_type: 'NBA', status: 1
  },
  {
    id: 315, entity_name: 'Memphis Grizzlies', import_key: 'Memphis', entity_type: 'NBA', status: 1
  },
  {
    id: 316, entity_name: 'Miami Heat', import_key: 'Miami', entity_type: 'NBA', status: 1
  },
  {
    id: 317, entity_name: 'Milwaukee Bucks', import_key: 'Milwaukee', entity_type: 'NBA', status: 1
  },
  {
    id: 318, entity_name: 'Minnesota Timberwolves', import_key: 'Minnesota', entity_type: 'NBA', status: 1
  },
  {
    id: 319, entity_name: 'New Orleans Pelicans', import_key: 'New Orleans', entity_type: 'NBA', status: 1
  },
  {
    id: 320, entity_name: 'New York Knicks', import_key: 'New York', entity_type: 'NBA', status: 1
  },
  {
    id: 321, entity_name: 'Oklahoma City Thunder', import_key: 'Oklahoma', entity_type: 'NBA', status: 1
  },
  {
    id: 322, entity_name: 'Orlando Magic', import_key: 'Orlando', entity_type: 'NBA', status: 1
  },
  {
    id: 323, entity_name: 'Philadelphia 76ers', import_key: 'Philadelphia', entity_type: 'NBA', status: 1
  },
  {
    id: 324, entity_name: 'Phoenix Suns', import_key: 'Phoenix', entity_type: 'NBA', status: 1
  },
  {
    id: 325, entity_name: 'Portland Trail Blazers', import_key: 'Portland', entity_type: 'NBA', status: 1
  },
  {
    id: 326, entity_name: 'Sacramento Kings', import_key: 'Sacramento', entity_type: 'NBA', status: 1
  },
  {
    id: 327, entity_name: 'San Antonio Spurs', import_key: 'San Antonio', entity_type: 'NBA', status: 1
  },
  {
    id: 328, entity_name: 'Toronto Raptors', import_key: 'Toronto', entity_type: 'NBA', status: 1
  },
  {
    id: 329, entity_name: 'Utah Jazz', import_key: 'Utah', entity_type: 'NBA', status: 1
  },
  {
    id: 330, entity_name: 'Washington Wizards', import_key: 'Washington', entity_type: 'NBA', status: 1
  },
  {
    id: 401, entity_name: 'Arizona Cardinals', import_key: 'Arizona', entity_type: 'NFL', status: 1
  },
  {
    id: 402, entity_name: 'Atlanta Falcons', import_key: 'Atlanta', entity_type: 'NFL', status: 1
  },
  {
    id: 403, entity_name: 'Baltimore Ravens', import_key: 'Baltimore', entity_type: 'NFL', status: 1
  },
  {
    id: 404, entity_name: 'Buffalo Bills', import_key: 'Buffalo', entity_type: 'NFL', status: 1
  },
  {
    id: 405, entity_name: 'Carolina Panthers', import_key: 'Carolina', entity_type: 'NFL', status: 1
  },
  {
    id: 406, entity_name: 'Chicago Bears', import_key: 'Chicago', entity_type: 'NFL', status: 1
  },
  {
    id: 407, entity_name: 'Cincinnati Bengals', import_key: 'Cincinnati', entity_type: 'NFL', status: 1
  },
  {
    id: 408, entity_name: 'Cleveland Browns', import_key: 'Cleveland', entity_type: 'NFL', status: 1
  },
  {
    id: 409, entity_name: 'Dallas Cowboys', import_key: 'Dallas', entity_type: 'NFL', status: 1
  },
  {
    id: 410, entity_name: 'Denver Broncos', import_key: 'Denver', entity_type: 'NFL', status: 1
  },
  {
    id: 411, entity_name: 'Detroit Lions', import_key: 'Detroit', entity_type: 'NFL', status: 1
  },
  {
    id: 412, entity_name: 'Green Bay Packers', import_key: 'Green Bay', entity_type: 'NFL', status: 1
  },
  {
    id: 413, entity_name: 'Houston Texans', import_key: 'Houston', entity_type: 'NFL', status: 1
  },
  {
    id: 414, entity_name: 'Indianapolis Colts', import_key: 'Indianapolis', entity_type: 'NFL', status: 1
  },
  {
    id: 415, entity_name: 'Jacksonville Jaguars', import_key: 'Jacksonville', entity_type: 'NFL', status: 1
  },
  {
    id: 416, entity_name: 'Kansas City Chiefs', import_key: 'Kansas City', entity_type: 'NFL', status: 1
  },
  {
    id: 417, entity_name: 'Miami Dolphins', import_key: 'Miami', entity_type: 'NFL', status: 1
  },
  {
    id: 418, entity_name: 'Minnesota Vikings', import_key: 'Minnesota', entity_type: 'NFL', status: 1
  },
  {
    id: 419, entity_name: 'New England Patriots', import_key: 'New England', entity_type: 'NFL', status: 1
  },
  {
    id: 420, entity_name: 'New Orleans Saints', import_key: 'New Orleans', entity_type: 'NFL', status: 1
  },
  {
    id: 421, entity_name: 'New York Giants', import_key: 'NY Giants', entity_type: 'NFL', status: 1
  },
  {
    id: 422, entity_name: 'New York Jets', import_key: 'NY Jets', entity_type: 'NFL', status: 1
  },
  {
    id: 423, entity_name: 'Oakland Raiders', import_key: 'Oakland', entity_type: 'NFL', status: 1
  },
  {
    id: 424, entity_name: 'Philadelphia Eagles', import_key: 'Philadelphia', entity_type: 'NFL', status: 1
  },
  {
    id: 425, entity_name: 'Pittsburgh Steelers', import_key: 'Pittsburgh', entity_type: 'NFL', status: 1
  },
  {
    id: 426, entity_name: 'San Diego Chargers', import_key: 'San Diego', entity_type: 'NFL', status: 1
  },
  {
    id: 427, entity_name: 'San Francisco 49ers', import_key: 'San Francisco', entity_type: 'NFL', status: 1
  },
  {
    id: 428, entity_name: 'Seattle Seahawks', import_key: 'Seattle', entity_type: 'NFL', status: 1
  },
  {
    id: 429, entity_name: 'St. Louis Rams', import_key: 'St. Louis', entity_type: 'NFL', status: 1
  },
  {
    id: 430, entity_name: 'Tampa Bay Buccaneers', import_key: 'Tampa Bay', entity_type: 'NFL', status: 1
  },
  {
    id: 431, entity_name: 'Tennessee Titans', import_key: 'Tennessee', entity_type: 'NFL', status: 1
  },
  {
    id: 432, entity_name: 'Washington Redskins', import_key: 'Washington', entity_type: 'NFL', status: 1
  }
]);