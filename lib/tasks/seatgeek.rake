namespace :seatgeek do
  desc 'Update entities to have SeatGeek import keys'
  task update_entities: :environment do
    Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']

    puts "[START] #{DateTime.now}"

    puts 'Retrieving SeatGeek Data'
    entity_types = EntityType.all
    seatgeek_data = {}
    entity_types.each do |et|
      next unless et.seatgeek?
      puts "Retrieving #{et.display_name} data"
      params = Rack::Utils.parse_query URI(et.import_key).query
      params[:per_page] = 1000
      response = SeatGeek::Connection.performers(params)
      seatgeek_data[et.import_key] = response['performers']
    end

    entities = Entity.active
    puts 'Finding SeatGeek Entities'
    entities.each do |entity|
      next if seatgeek_data[entity.entity_type.import_key].nil?
      puts "Searching for #{entity.display_name} in API Data"
      seatgeek_data[entity.entity_type.import_key].each do |performer|
        next unless performer['name'] == entity.entity_name
        unless performer['home_venue_id']
          puts '- No home venue!'
          next
        end
        entity.import_key = 'https://api.seatgeek.com/2/events'\
          "?performers.slug=#{performer['slug']}"\
          "&venue.id=#{performer['home_venue_id']}"
        entity.save!
        puts '- Updated!'
      end
    end
    puts 'Done!'
    puts "[END] #{DateTime.now}"
  end

  desc 'Update events for entities with SeatGeek import keys'
  task update_events: :environment do
    Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']

    puts "[START] #{DateTime.now}"
    entities = Entity.select(&:seatgeek?)
    puts 'Updating SeatGeek schedules'
    entities.each do |entity|
      puts "Updating schedule for #{entity.display_name}"
      events = entity.seatgeek_import
      if events.nil?
        puts '[Error!] No response from API. Probably being rate limited.'
        sleep 2
        next
      end
      case events
      when String
        puts "- #{events}"
      when Array
        puts "- Updated #{events.count} events"
      end
    end
    puts 'Done!'
    puts "[END] #{DateTime.now}"
  end
end
