ActiveAdmin.register Event do

  action_item :only => :index do
    link_to 'Import JSON Schedule', :action => 'import_json'
  end

  collection_action :import_json, :method => :get
  collection_action :import_json, :method => :post do

    @page_title = 'Import JSON Schedule'

    if !params[:json_file].nil?
      entities = Entity.get_by_entity_type(params[:entity_type])
      if entities.nil? || entities.count == 0
        raise "InvalidEntityType"
      end

      uploaded_io = params[:json_file]
      if uploaded_io.respond_to?(:read)
        json_contents = uploaded_io.read
      elsif uploaded_io.respond_to?(:path)
        json_contents = File.read(uploaded_io.path)
      else
        logger.error "Bad uploaded_io: #{uploaded_io.class.name}: #{uploaded_io.inspect}"
      end

      schedule = JSON.parse(json_contents)
      @events_list = []
      for row in schedule
        entity = entities.find_by_import_key(row['home_team'])
        puts entity.inspect
        if entity.nil?
          raise "InvalidImportKey[#{row['home_team']}]"
        end
        event = Event.new({
          entity_id:  entity.id,
          event_name: row['event_name'],
          start_time: row['iso_datetime'],

        })
        if params[:confirm]
          event.save!
        end
        @events_list << event
      end
      if params[:confirm]
         flash[:success] = 'Events imported!'
        redirect_to admin_events_path and return
      end
    end

  end

end
