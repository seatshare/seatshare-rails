##
# Entity model
class Entity < ActiveRecord::Base
  has_many :tickets, through: :events
  has_many :groups
  has_many :events
  belongs_to :entity_type

  validates :entity_name, presence: true, uniqueness: { scope: :entity_type }
  before_save :clean_import_key

  scope :by_name, -> { order('LOWER(entity_name) ASC') }
  scope :active, -> { where('status = 1') }

  ##
  # New entity object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      status: 0,
      import_key: generate_import_key(attributes)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  ##
  # Display name for entity
  def display_name
    "#{entity_name} (#{entity_type.entity_type_abbreviation})"
  end

  ##
  # Is SeatGeek?
  def seatgeek?
    import_key.include? 'api.seatgeek.com'
  end

  ##
  # Import SeatGeek Events
  # - overwrite: whether to overwrite the title and description
  def seatgeek_import(overwrite = false)
    fail 'Not a SeatGeek entity' unless seatgeek?
    params = Rack::Utils.parse_query URI(import_key).query
    params[:per_page] = 500
    response = SeatGeek::Connection.events(params)
    fail 'No events.' unless response && response['events'].count > 0
    records = []
    response['events'].each do |event|
      venue = event['venue']
      records << Event.import(
        {
          import_key: "https://api.seatgeek.com/2/events?id=#{event['id']}",
          event_name: event['title'],
          description: "#{venue['name']} (#{venue['display_location']})",
          entity_id: id,
          start_time: "#{event['datetime_utc']}+00:00",
          date_tba: event['datetime_tbd'],
          time_tba: event['time_tbd']
        }, overwrite
      )
    end
    records
  rescue StandardError => e
    logger.info e.message
    return e.message
  end

  private

  ##
  # Generate a unique import key for new entities
  def generate_import_key(attributes)
    et = EntityType.find(attributes[:entity_type_id]) || nil
    if et.nil?
      "#{attributes[:entity_type_id]}: #{attributes[:entity_name]}".parameterize
    else
      "#{et.entity_type_abbreviation}: #{attributes[:entity_name]}".parameterize
    end
  end

  ##
  # Run generate import key if empty
  def clean_import_key
    self.import_key = generate_import_key(self) if import_key.blank?
  end
end
