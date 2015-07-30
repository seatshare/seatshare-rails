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
    column :tickets do |event|
      link_to event.tickets.count, admin_tickets_path(q: { event_id_eq: event.id })
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

  action_item 'import', only: :index do
    link_to 'Import from SODA', action: 'import_soda'
  end

  action_item 'import', only: :index do
    link_to 'Import from File', action: 'import_file'
  end

  show do
    attributes_table do
      row :id
      row :event_name
      row :entity
      row :description
      row :start_time
      row :date_tba
      row :time_tba
      row :created_at
      row :updated_at
      row :import_key
    end

    panel "Tickets" do
      table_for resource.tickets do |ticket|
        column :display_name do |t|
          auto_link(t, t.display_name)
        end
        column :group do |t|
          auto_link(t.group, t.group.display_name)
        end
        column :owner
        column :user
        column :alias
        column :cost do |t|
          number_to_currency t.cost
        end
      end
    end
  end

  collection_action :import_soda, method: :get
  collection_action :import_soda, method: :post do
    @page_title = 'Import from SODA'

    # Build entity list
    @entities = {}
    Entity.active.is_soda.group_by(&:entity_type).each do |entity_type, entity|
      @entities[entity_type] = [] if @entities[entity_type].nil?
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
      params[:team_id].each do |team_id|
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

  collection_action :import_file, method: :get
  collection_action :import_file, method: :post do
    @page_title = 'Import from File'

    unless params[:file].nil?

      # Used to display the list back upon completion
      @events_list = []

      # Used to flash messages describing error or success
      @messages = []

      # Loop through team ids and run importer
      importer = FileScheduleImport.new
      importer.run(
        file: params[:file],
      )

      @events_list += importer.events_list
      @messages += importer.messages
    end
  end

end
