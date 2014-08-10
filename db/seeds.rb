# Files are split into the ./db/seeds/ directory

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }
