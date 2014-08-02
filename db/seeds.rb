# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create([
  {
    email: 'stephen@seatsha.re', password: 'password', password_confirmation: 'password'
  }
])

Entity.create([
  {
    id: 101, entity_name: 'Anaheim Ducks', import_key: 'l.nhl.com-t.22', entity_type: 'NHL', status: 1
  },
  {
    id: 102, entity_name: 'Arizona Coyotes', import_key: 'l.nhl.com-t.25', entity_type: 'NHL', status: 1
  },
  {
    id: 103, entity_name: 'Boston Bruins', import_key: 'l.nhl.com-t.11', entity_type: 'NHL', status: 1
  },
  {
    id: 104, entity_name: 'Buffalo Sabres', import_key: 'l.nhl.com-t.12', entity_type: 'NHL', status: 1
  },
  {
    id: 105, entity_name: 'Calgary Flames', import_key: 'l.nhl.com-t.28', entity_type: 'NHL', status: 1
  },
  {
    id: 106, entity_name: 'Carolina Hurricanes', import_key: 'l.nhl.com-t.6', entity_type: 'NHL', status: 1
  },
  {
    id: 107, entity_name: 'Chicago Blackhawks', import_key: 'l.nhl.com-t.16', entity_type: 'NHL', status: 1
  },
  {
    id: 108, entity_name: 'Columbus Blue Jackets', import_key: 'l.nhl.com-t.20', entity_type: 'NHL', status: 1
  },
  {
    id: 109, entity_name: 'Colorado Avalanche', import_key: 'l.nhl.com-t.27', entity_type: 'NHL', status: 1
  },
  {
    id: 110, entity_name: 'Dallas Stars', import_key: 'l.nhl.com-t.21', entity_type: 'NHL', status: 1
  },
  {
    id: 111, entity_name: 'Detroit Red Wings', import_key: 'l.nhl.com-t.17', entity_type: 'NHL', status: 1
  },
  {
    id: 112, entity_name: 'Edmonton Oilers', import_key: 'l.nhl.com-t.29', entity_type: 'NHL', status: 1
  },
  {
    id: 113, entity_name: 'Florida Panthers', import_key: 'l.nhl.com-t.10', entity_type: 'NHL', status: 1
  },
  {
    id: 114, entity_name: 'Los Angeles Kings', import_key: 'l.nhl.com-t.23', entity_type: 'NHL', status: 1
  },
  {
    id: 115, entity_name: 'Minnesota Wild', import_key: 'l.nhl.com-t.30', entity_type: 'NHL', status: 1
  },
  {
    id: 116, entity_name: 'Montréal Canadiens', import_key: 'l.nhl.com-t.13', entity_type: 'NHL', status: 1
  },
  {
    id: 117, entity_name: 'Nashville Predators', import_key: 'l.nhl.com-t.19', entity_type: 'NHL', status: 1
  },
  {
    id: 118, entity_name: 'New Jersey Devils', import_key: 'l.nhl.com-t.1', entity_type: 'NHL', status: 1
  },
  {
    id: 119, entity_name: 'New York Islanders', import_key: 'l.nhl.com-t.2', entity_type: 'NHL', status: 1
  },
  {
    id: 120, entity_name: 'New York Rangers', import_key: 'l.nhl.com-t.3', entity_type: 'NHL', status: 1
  },
  {
    id: 121, entity_name: 'Ottawa Senators', import_key: 'l.nhl.com-t.14', entity_type: 'NHL', status: 1
  },
  {
    id: 122, entity_name: 'Philadelphia Flyers', import_key: 'l.nhl.com-t.4', entity_type: 'NHL', status: 1
  },
  {
    id: 123, entity_name: 'Pittsburgh Penguins', import_key: 'l.nhl.com-t.5', entity_type: 'NHL', status: 1
  },
  {
    id: 124, entity_name: 'San Jose Sharks', import_key: 'l.nhl.com-t.24', entity_type: 'NHL', status: 1
  },
  {
    id: 125, entity_name: 'St. Louis Blues', import_key: 'l.nhl.com-t.18', entity_type: 'NHL', status: 1
  },
  {
    id: 126, entity_name: 'Tampa Bay Lightning', import_key: 'l.nhl.com-t.7', entity_type: 'NHL', status: 1
  },
  {
    id: 127, entity_name: 'Toronto Maple Leafs', import_key: 'l.nhl.com-t.15', entity_type: 'NHL', status: 1
  },
  {
    id: 128, entity_name: 'Vancouver Canucks', import_key: 'l.nhl.com-t.26', entity_type: 'NHL', status: 1
  },
  {
    id: 129, entity_name: 'Washington Capitals', import_key: 'l.nhl.com-t.8', entity_type: 'NHL', status: 1
  },
  {
    id: 130, entity_name: 'Winnipeg Jets', import_key: 'l.nhl.com-t.9', entity_type: 'NHL', status: 1
  },
  {
    id: 201, entity_name: 'Anaheim Angels', import_key: 'l.mlb.com-t.11', entity_type: 'MLB', status: 1
  },
  {
    id: 202, entity_name: 'Arizona Diamondbacks', import_key: 'l.mlb.com-t.26', entity_type: 'MLB', status: 1
  },
  {
    id: 203, entity_name: 'Atlanta Braves', import_key: 'l.mlb.com-t.15', entity_type: 'MLB', status: 1
  },
  {
    id: 204, entity_name: 'Baltimore Orioles', import_key: 'l.mlb.com-t.1', entity_type: 'MLB', status: 1
  },
  {
    id: 205, entity_name: 'Boston Red Sox', import_key: 'l.mlb.com-t.2', entity_type: 'MLB', status: 1
  },
  {
    id: 206, entity_name: 'Chicago Cubs', import_key: 'l.mlb.com-t.20', entity_type: 'MLB', status: 1
  },
  {
    id: 207, entity_name: 'Chicago White Sox', import_key: 'l.mlb.com-t.6', entity_type: 'MLB', status: 1
  },
  {
    id: 208, entity_name: 'Cincinnati Reds', import_key: 'l.mlb.com-t.21', entity_type: 'MLB', status: 1
  },
  {
    id: 209, entity_name: 'Cleveland Indians', import_key: 'l.mlb.com-t.7', entity_type: 'MLB', status: 1
  },
  {
    id: 210, entity_name: 'Colorado Rockies', import_key: 'l.mlb.com-t.27', entity_type: 'MLB', status: 1
  },
  {
    id: 211, entity_name: 'Detroit Tigers', import_key: 'l.mlb.com-t.8', entity_type: 'MLB', status: 1
  },
  {
    id: 212, entity_name: 'Houston Astros', import_key: 'l.mlb.com-t.22', entity_type: 'MLB', status: 1
  },
  {
    id: 213, entity_name: 'Kansas City Royals', import_key: 'l.mlb.com-t.9', entity_type: 'MLB', status: 1
  },
  {
    id: 214, entity_name: 'Los Angeles Dodgers', import_key: 'l.mlb.com-t.28', entity_type: 'MLB', status: 1
  },
  {
    id: 215, entity_name: 'Miami Marlins', import_key: 'l.mlb.com-t.16', entity_type: 'MLB', status: 1
  },
  {
    id: 216, entity_name: 'Milwaukee Brewers', import_key: 'l.mlb.com-t.23', entity_type: 'MLB', status: 1
  },
  {
    id: 217, entity_name: 'Minnesota Twins', import_key: 'l.mlb.com-t.10', entity_type: 'MLB', status: 1
  },
  {
    id: 218, entity_name: 'New York Mets', import_key: 'l.mlb.com-t.18', entity_type: 'MLB', status: 1
  },
  {
    id: 219, entity_name: 'New York Yankees', import_key: 'l.mlb.com-t.3', entity_type: 'MLB', status: 1
  },
  {
    id: 220, entity_name: 'Oakland Athletics', import_key: 'l.mlb.com-t.12', entity_type: 'MLB', status: 1
  },
  {
    id: 221, entity_name: 'Philadelphia Phillies', import_key: 'l.mlb.com-t.19', entity_type: 'MLB', status: 1
  },
  {
    id: 222, entity_name: 'Pittsburgh Pirates', import_key: 'l.mlb.com-t.24', entity_type: 'MLB', status: 1
  },
  {
    id: 223, entity_name: 'San Diego Padres', import_key: 'l.mlb.com-t.29', entity_type: 'MLB', status: 1
  },
  {
    id: 224, entity_name: 'San Francisco Giants', import_key: 'l.mlb.com-t.30', entity_type: 'MLB', status: 1
  },
  {
    id: 225, entity_name: 'Seattle Mariners', import_key: 'l.mlb.com-t.13', entity_type: 'MLB', status: 1
  },
  {
    id: 226, entity_name: 'St. Louis Cardinals', import_key: 'l.mlb.com-t.25', entity_type: 'MLB', status: 1
  },
  {
    id: 227, entity_name: 'Tampa Bay Rays', import_key: 'l.mlb.com-t.4', entity_type: 'MLB', status: 1
  },
  {
    id: 228, entity_name: 'Texas Rangers', import_key: 'l.mlb.com-t.14', entity_type: 'MLB', status: 1
  },
  {
    id: 229, entity_name: 'Toronto Blue Jays', import_key: 'l.mlb.com-t.5', entity_type: 'MLB', status: 1
  },
  {
    id: 230, entity_name: 'Washington Nationals', import_key: 'l.mlb.com-t.17', entity_type: 'MLB', status: 1
  },
  {
    id: 301, entity_name: 'Atlanta Hawks', import_key: 'l.nba.com-t.8', entity_type: 'NBA', status: 1
  },
  {
    id: 302, entity_name: 'Boston Celtics', import_key: 'l.nba.com-t.1', entity_type: 'NBA', status: 1
  },
  {
    id: 303, entity_name: 'Brooklyn Nets', import_key: 'l.nba.com-t.3', entity_type: 'NBA', status: 1
  },
  {
    id: 304, entity_name: 'Charlotte Hornets', import_key: 'l.nba.com-t.32', entity_type: 'NBA', status: 1
  },
  {
    id: 305, entity_name: 'Chicago Bulls', import_key: 'l.nba.com-t.10', entity_type: 'NBA', status: 1
  },
  {
    id: 306, entity_name: 'Cleveland Cavaliers', import_key: 'l.nba.com-t.11', entity_type: 'NBA', status: 1
  },
  {
    id: 307, entity_name: 'Dallas Mavericks', import_key: 'l.nba.com-t.16', entity_type: 'NBA', status: 1
  },
  {
    id: 308, entity_name: 'Denver Nuggets', import_key: 'l.nba.com-t.17', entity_type: 'NBA', status: 1
  },
  {
    id: 309, entity_name: 'Detroit Pistons', import_key: 'l.nba.com-t.12', entity_type: 'NBA', status: 1
  },
  {
    id: 310, entity_name: 'Golden State Warriors', import_key: 'l.nba.com-t.23', entity_type: 'NBA', status: 1
  },
  {
    id: 311, entity_name: 'Houston Rockets', import_key: 'l.nba.com-t.18', entity_type: 'NBA', status: 1
  },
  {
    id: 312, entity_name: 'Indiana Pacers', import_key: 'l.nba.com-t.13', entity_type: 'NBA', status: 1
  },
  {
    id: 313, entity_name: 'Los Angeles Clippers', import_key: 'l.nba.com-t.24', entity_type: 'NBA', status: 1
  },
  {
    id: 314, entity_name: 'Los Angeles Lakers', import_key: 'l.nba.com-t.25', entity_type: 'NBA', status: 1
  },
  {
    id: 315, entity_name: 'Memphis Grizzlies', import_key: 'l.nba.com-t.19', entity_type: 'NBA', status: 1
  },
  {
    id: 316, entity_name: 'Miami Heat', import_key: 'l.nba.com-t.2', entity_type: 'NBA', status: 1
  },
  {
    id: 317, entity_name: 'Milwaukee Bucks', import_key: 'l.nba.com-t.14', entity_type: 'NBA', status: 1
  },
  {
    id: 318, entity_name: 'Minnesota Timberwolves', import_key: 'l.nba.com-t.20', entity_type: 'NBA', status: 1
  },
  {
    id: 319, entity_name: 'New Orleans Pelicans', import_key: 'l.nba.com-t.9', entity_type: 'NBA', status: 1
  },
  {
    id: 320, entity_name: 'New York Knicks', import_key: 'l.nba.com-t.4', entity_type: 'NBA', status: 1
  },
  {
    id: 321, entity_name: 'Oklahoma City Thunder', import_key: 'l.nba.com-t.29', entity_type: 'NBA', status: 1
  },
  {
    id: 322, entity_name: 'Orlando Magic', import_key: 'l.nba.com-t.5', entity_type: 'NBA', status: 1
  },
  {
    id: 323, entity_name: 'Philadelphia 76ers', import_key: 'l.nba.com-t.6', entity_type: 'NBA', status: 1
  },
  {
    id: 324, entity_name: 'Phoenix Suns', import_key: 'l.nba.com-t.26', entity_type: 'NBA', status: 1
  },
  {
    id: 325, entity_name: 'Portland Trail Blazers', import_key: 'l.nba.com-t.27', entity_type: 'NBA', status: 1
  },
  {
    id: 326, entity_name: 'Sacramento Kings', import_key: 'l.nba.com-t.28', entity_type: 'NBA', status: 1
  },
  {
    id: 327, entity_name: 'San Antonio Spurs', import_key: 'l.nba.com-t.21', entity_type: 'NBA', status: 1
  },
  {
    id: 328, entity_name: 'Toronto Raptors', import_key: 'l.nba.com-t.15', entity_type: 'NBA', status: 1
  },
  {
    id: 329, entity_name: 'Utah Jazz', import_key: 'l.nba.com-t.22', entity_type: 'NBA', status: 1
  },
  {
    id: 330, entity_name: 'Washington Wizards', import_key: 'l.nba.com-t.7', entity_type: 'NBA', status: 1
  },
  {
    id: 401, entity_name: 'Arizona Cardinals', import_key: 'l.nfl.com-t.17', entity_type: 'NFL', status: 1
  },
  {
    id: 402, entity_name: 'Atlanta Falcons', import_key: 'l.nfl.com-t.27', entity_type: 'NFL', status: 1
  },
  {
    id: 403, entity_name: 'Baltimore Ravens', import_key: 'l.nfl.com-t.6', entity_type: 'NFL', status: 1
  },
  {
    id: 404, entity_name: 'Buffalo Bills', import_key: 'l.nfl.com-t.1', entity_type: 'NFL', status: 1
  },
  {
    id: 405, entity_name: 'Carolina Panthers', import_key: 'l.nfl.com-t.29', entity_type: 'NFL', status: 1
  },
  {
    id: 406, entity_name: 'Chicago Bears', import_key: 'l.nfl.com-t.22', entity_type: 'NFL', status: 1
  },
  {
    id: 407, entity_name: 'Cincinnati Bengals', import_key: 'l.nfl.com-t.7', entity_type: 'NFL', status: 1
  },
  {
    id: 408, entity_name: 'Cleveland Browns', import_key: 'l.nfl.com-t.8', entity_type: 'NFL', status: 1
  },
  {
    id: 409, entity_name: 'Dallas Cowboys', import_key: 'l.nfl.com-t.18', entity_type: 'NFL', status: 1
  },
  {
    id: 410, entity_name: 'Denver Broncos', import_key: 'l.nfl.com-t.12', entity_type: 'NFL', status: 1
  },
  {
    id: 411, entity_name: 'Detroit Lions', import_key: 'l.nfl.com-t.23', entity_type: 'NFL', status: 1
  },
  {
    id: 412, entity_name: 'Green Bay Packers', import_key: 'l.nfl.com-t.24', entity_type: 'NFL', status: 1
  },
  {
    id: 413, entity_name: 'Houston Texans', import_key: 'l.nfl.com-t.32', entity_type: 'NFL', status: 1
  },
  {
    id: 414, entity_name: 'Indianapolis Colts', import_key: 'l.nfl.com-t.2', entity_type: 'NFL', status: 1
  },
  {
    id: 415, entity_name: 'Jacksonville Jaguars', import_key: 'l.nfl.com-t.9', entity_type: 'NFL', status: 1
  },
  {
    id: 416, entity_name: 'Kansas City Chiefs', import_key: 'l.nfl.com-t.13', entity_type: 'NFL', status: 1
  },
  {
    id: 417, entity_name: 'Miami Dolphins', import_key: 'l.nfl.com-t.3', entity_type: 'NFL', status: 1
  },
  {
    id: 418, entity_name: 'Minnesota Vikings', import_key: 'l.nfl.com-t.25', entity_type: 'NFL', status: 1
  },
  {
    id: 419, entity_name: 'New England Patriots', import_key: 'l.nfl.com-t.4', entity_type: 'NFL', status: 1
  },
  {
    id: 420, entity_name: 'New Orleans Saints', import_key: 'l.nfl.com-t.30', entity_type: 'NFL', status: 1
  },
  {
    id: 421, entity_name: 'New York Giants', import_key: 'l.nfl.com-t.19', entity_type: 'NFL', status: 1
  },
  {
    id: 422, entity_name: 'New York Jets', import_key: 'l.nfl.com-t.5', entity_type: 'NFL', status: 1
  },
  {
    id: 423, entity_name: 'Oakland Raiders', import_key: 'l.nfl.com-t.14', entity_type: 'NFL', status: 1
  },
  {
    id: 424, entity_name: 'Philadelphia Eagles', import_key: 'l.nfl.com-t.20', entity_type: 'NFL', status: 1
  },
  {
    id: 425, entity_name: 'Pittsburgh Steelers', import_key: 'l.nfl.com-t.10', entity_type: 'NFL', status: 1
  },
  {
    id: 426, entity_name: 'San Diego Chargers', import_key: 'l.nfl.com-t.15', entity_type: 'NFL', status: 1
  },
  {
    id: 427, entity_name: 'San Francisco 49ers', import_key: 'l.nfl.com-t.31', entity_type: 'NFL', status: 1
  },
  {
    id: 428, entity_name: 'Seattle Seahawks', import_key: 'l.nfl.com-t.16', entity_type: 'NFL', status: 1
  },
  {
    id: 429, entity_name: 'St. Louis Rams', import_key: 'l.nfl.com-t.28', entity_type: 'NFL', status: 1
  },
  {
    id: 430, entity_name: 'Tampa Bay Buccaneers', import_key: 'l.nfl.com-t.26', entity_type: 'NFL', status: 1
  },
  {
    id: 431, entity_name: 'Tennessee Titans', import_key: 'l.nfl.com-t.11', entity_type: 'NFL', status: 1
  },
  {
    id: 432, entity_name: 'Washington Redskins', import_key: 'l.nfl.com-t.21', entity_type: 'NFL', status: 1
  }
]);