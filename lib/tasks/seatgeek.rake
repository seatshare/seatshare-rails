namespace :seatgeek do
  desc 'Update entities to have SeatGeek import keys'
  task update_entities: :environment do
    Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']

    puts "[START] #{Time.zone.now}"

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
    replace = 'basketball|baseball|softball|football|womens basketball'
    entities.each do |e|
      next if seatgeek_data[e.entity_type.import_key].nil?
      puts "Searching for #{e.display_name} in API Data"
      seatgeek_data[e.entity_type.import_key].each do |p|
        next unless p['name'].match(/^#{e.entity_name}\s?(?:#{replace})?$/i)
        unless p['home_venue_id']
          puts '- No home venue!'
          next
        end
        e.import_key = 'https://api.seatgeek.com/2/events'\
          "?performers.slug=#{p['slug']}"\
          "&venue.id=#{p['home_venue_id']}"
        e.save!
        puts '- Updated!'
      end
    end
    puts 'Done!'
    puts "[END] #{Time.zone.now}"
  end

  desc 'Update events for entities with SeatGeek import keys'
  task update_events: :environment do
    Time.zone = ActiveSupport::TimeZone['Central Time (US & Canada)']

    puts "[START] #{Time.zone.now}"
    entities = Entity.select(&:seatgeek?)
    puts 'Updating SeatGeek schedules'
    entities.each do |entity|
      next if entity.groups.count == 0
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
    puts "[END] #{Time.zone.now}"
  end
end
