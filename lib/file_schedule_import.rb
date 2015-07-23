##
# File Schedule Import class
class FileScheduleImport
  attr_accessor :messages, :events_list

  ##
  # Initialize new object
  def initialize
    self.messages = []
    self.events_list = []
  end

  ##
  # Run the importer
  def run(options = {})
    # Parse the uploaded file
    schedule_document = Nokogiri::XML(options[:file].read)

    # Obtain the Entity from the header
    team_id = nil
    schedule_document.css(
      'sports-metadata sports-content-codes '\
      'sports-content-code[@code-type="team"]'
    ).each do |sportscontent|
      team_id = sportscontent['code-key']
    end
    if team_id.nil?
      messages << 'Unable to find an Entity to associate with this schedule'
      return
    else
      entity = Entity.find_by_import_key(team_id)
      if entity.nil?
        messages << "Could not find entity that matched #{team_id}"
        return
      end
    end

    # Parse the schedule and create the events
    schedule = SodaXmlTeam::Schedule.parse_schedule(schedule_document)

    schedule.each do |row|
      # Map in entity_id for import
      row[:entity_id] = entity.id

      # Skip the away games
      next unless row[:home_team_id] == entity.import_key

      # Create or update the row
      events_list << Event.import(row)
    end

    # Done with that team
    messages << 'Schedule imported!'
  end
end
