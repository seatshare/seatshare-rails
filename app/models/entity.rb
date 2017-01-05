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
  scope :active, -> { where(status: true) }

  ##
  # New entity object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      status: false,
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
    response = seatgeek_schedule
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
          date_tba: event['date_tbd'],
          time_tba: event['time_tbd']
        }, overwrite
      )
    end
    records
  rescue StandardError => e
    logger.info e.message
    return e.message
  end

  ##
  # SeatGeek Schedule
  def seatgeek_schedule
    raise 'Not a SeatGeek entity' unless seatgeek?
    params = Rack::Utils.parse_query URI(import_key).query
    params[:per_page] = 500
    response = SeatGeek::Connection.events(params)
    raise response[:body] if response.key?(:status) && response[:status] != 200
    raise 'No events.' unless response && response['events'].count > 0
    response
  end

  ##
  # SeatGeek Performer
  def seatgeek_performer
    raise 'Not a SeatGeek entity' unless seatgeek?
    params = Rack::Utils.parse_query URI(import_key).query
    response = SeatGeek::Connection.performers(slug: params['performers.slug'])
    raise response[:body] if response.key?(:status) && response[:status] != 200
    raise 'No performer data.' unless response['performers'].count > 0
    response['performers'].first
  end

  ##
  # Entity Avatar
  def default_avatar(style = nil)
    style = 'medium' if style.nil?
    abbr = entity_type.entity_type_abbreviation.downcase
    image_path = File.join 'entity_types', "#{abbr}-group-#{style}-missing.png"
    if File.exist?(File.join(Rails.root, 'app', 'assets', 'images', image_path))
      ActionController::Base.helpers.asset_path image_path
    else
      ActionController::Base.helpers.asset_path("group-#{style}-missing.png")
    end
  end

  ##
  # JSON-LD
  def to_json_ld
    json = {
      :@context => 'http://schema.org',
      :@type => 'SportsTeam',
      :name => entity_name,
      :image => default_avatar,
      :memberOf => {
        :@type => 'SportsOrganization',
        :name => entity_type.entity_type_name
      }
    }.to_json
    "<script type='application/ld+json'>#{json}</script>"
  end

  private

  ##
  # Generate a unique import key for new entities
  def generate_import_key(attributes)
    et = EntityType.find_by(id: attributes[:entity_type_id]) || nil
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
