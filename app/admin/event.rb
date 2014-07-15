ActiveAdmin.register Event do

  index do
    selectable_column
    id_column
    column :event_name
    column :description
    column :start_time
    column :entity
    column :import_key
    actions
  end

  filter :entity
  filter :event_name
  filter :description
  filter :start_time
  filter :import_key

  action_item :only => :index do
    link_to 'Import from SODA', :action => 'import_soda'
  end

  collection_action :import_soda, :method => :get
  collection_action :import_soda, :method => :post do

    @page_title = 'Import from SODA'

    # Build entity list
    @entities = {}
    Entity.where("import_key != ''").where("status = 1").group_by(&:entity_type).each do |entity_type, entity|
      if @entities[entity_type].nil?
        @entities[entity_type] = []
      end
      @entities[entity_type] << entity
    end

    @start_datetime = params[:start_datetime] || Time.new
    @end_datetime = params[:end_datetime] || Time.new + 60*60*24*365
    @force_update = params[:force_update] || false

    if !params[:team_id].nil?

      # Used to display the list back upon completion
      @events_list = []

      # Used to flash messages describing error or success
      @messages = []

      # Connect to SODA
      soda = SodaXmlTeam::Client.new(ENV['SODA_USERNAME'], ENV['SODA_PASSWORD'])

      # First, we're going to work with each entity individually
      for team_id in params[:team_id]

        entity = Entity.find_by_import_key(team_id) || @messages << "Team #{team_id} not found in database!"
        league_id = team_id.split("-")[0]

        listing = soda.get_listing({
          sandbox: ENV['SODA_ENVIRONMENT'] != 'production',
          league_id: league_id,
          team_id: team_id,
          type: 'schedule-single-team',
          start_datetime: DateTime.parse(params[:start_datetime]),
          end_datetime: DateTime.parse(params[:end_datetime])
        })

        # See if there were any documents at all
        if listing.css('item link').length === 0
          @messages << "No events were available for #{entity.entity_name}."
          next
        end

        # Grab the latest URI available
        latest = URI.parse(listing.css('item link').first)
        document_id = CGI.parse(latest.query)['doc-ids'].first

        # Check to see if you already have this document ID
        if File.exists? File.join(Rails.root, 'tmp', 'soda', document_id)
          if params[:force_update] != "1"
            @messages << "Already downloaded schedule for #{entity.entity_name} as #{document_id}."
            next
          end
        end

        # Retrieve the document (this counts as using an API credit)
        schedule_document = soda.get_document({
          sandbox: ENV['SODA_ENVIRONMENT'] != 'production',
          document_id: document_id
        })

        # Cache the document to prevent re-downloads
        File.open File.join(Rails.root, 'tmp', 'soda', document_id), 'w' do |f|
          f.write schedule_document.to_s
        end

        # Parse the schedule and create the events
        schedule = SodaXmlTeam::Schedule.parse_schedule(schedule_document)
        for row in schedule

          # Map in entity_id for import
          row[:entity_id] = entity.id

          # Skip the away games
          if row[:home_team_id] != team_id
            next
          end

          # Create or update the row
          event = Event.import row

          @events_list << event
        end

        # Done with that team
        @messages << "#{entity.entity_name} schedule imported!"

      end

    end

  end

end
