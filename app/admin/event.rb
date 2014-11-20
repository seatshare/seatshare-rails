require 'soda_schedule_import'

ActiveAdmin.register Event do

  index do
    selectable_column
    id_column
    column :event_name
    column :description
    column :start_time do |event|
      event.date_time
    end
    column :entity
    column :import_key
    actions
  end

  filter :entity
  filter :event_name
  filter :description
  filter :start_time
  filter :import_key

  action_item only: :index do
    link_to 'Import from SODA', action: 'import_soda'
  end

  collection_action :import_soda, method: :get
  collection_action :import_soda, method: :post do

    @page_title = 'Import from SODA'

    # Build entity list
    @entities = {}
    Entity.active.is_soda.group_by(&:entity_type).each do |entity_type, entity|
      if @entities[entity_type].nil?
        @entities[entity_type] = []
      end
      @entities[entity_type] << entity
    end

    @start_datetime = params[:start_datetime] || Time.new - 60 * 60 * 24 * 30
    @end_datetime = params[:end_datetime] || Time.new
    @force_update = params[:force_update] || false

    unless params[:team_id].nil?

      # Used to display the list back upon completion
      @events_list = []

      # Used to flash messages describing error or success
      @messages = []

      # Loop through team ids and run importer
      for team_id in params[:team_id]

        importer = SodaScheduleImport.new
        importer.run(
          team_id: team_id,
          start_datetime: params[:start_datetime],
          end_datetime: params[:end_datetime],
          force_update: params[:force_update]
        )

        @events_list += importer.events_list
        @messages += importer.messages

      end

    end

  end

  sidebar 'Tickets', only: :show do
    ul do
      Event.find(resource.id).tickets.collect do |ticket|
        li auto_link(ticket)
      end
    end
  end

end
