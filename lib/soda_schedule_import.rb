class SodaScheduleImport

  attr_accessor :soda_client, :messages, :events_list

  def initialize
    self.soda_client = SodaXmlTeam::Client.new(ENV['SODA_USERNAME'], ENV['SODA_PASSWORD'])
    self.messages = []
    self.events_list = []
  end

  def run(options={})
    entity = Entity.find_by_import_key(options[:team_id])
    if entity.blank?
      self.messages << "Could not find an entity that matched #{options[:team_id]}"
      return
    end

    # Get listing for desired league
    documents = self.soda_client.content_finder({
      sandbox: ENV['SODA_ENVIRONMENT'] != 'production',
      league_id: options[:team_id].split("-")[0],
      team_id: options[:team_id],
      type: 'schedule-single-team',
      start_datetime: options[:start_datetime].is_a?(String) ? DateTime.parse(options[:start_datetime]) : options[:start_datetime],
      end_datetime: options[:end_datetime].is_a?(String) ? DateTime.parse(options[:end_datetime]) : options[:start_datetime]
    })

    # See if there were any documents at all
    if documents.length === 0 || !documents[0][:document_id]
      self.messages << "No events were available for #{entity.entity_name}."
      return
    end

    # Get the latest document
    document_id = documents[0][:document_id]

    # Check to see if you already have this document ID in S3
    s3 = AWS::S3.new
    if s3.buckets[ENV['SEATSHARE_S3_BUCKET']].objects["soda/#{document_id}"].exists?
      if !options[:force_update]
        self.messages << "The latest schedule for #{entity.entity_name} (#{document_id}) has already been processed."
        return
      end
    end

    # Retrieve the document (this counts as using an API credit)
    schedule_document = self.soda_client.get_document({
      sandbox: ENV['SODA_ENVIRONMENT'] != 'production',
      document_id: document_id
    })

    # Cache the document to prevent re-downloads
    File.open File.join(Rails.root, 'tmp', 'soda', document_id), 'w' do |file|
      file.write schedule_document.to_s
    end

    # Store this file in S3
    File.open File.join(Rails.root, 'tmp', 'soda', document_id), 'rb' do |file|
      s3 = AWS::S3.new
      object = s3.buckets[ENV['SEATSHARE_S3_BUCKET']].objects["soda/#{document_id}"]
      object.write(open(file))
    end

    # Parse the schedule and create the events
    schedule = SodaXmlTeam::Schedule.parse_schedule(schedule_document)
    for row in schedule

      # Map in entity_id for import
      row[:entity_id] = entity.id

      # Skip the away games
      if row[:home_team_id] != options[:team_id]
        next
      end

      # Create or update the row
      self.events_list << Event.import(row)
    end

    # Done with that team
    self.messages << "#{entity.entity_name} schedule imported!"
  end

end
