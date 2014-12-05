##
# Entity model
class Entity < ActiveRecord::Base
  has_many :tickets, through: :events
  has_many :groups
  has_many :events
  belongs_to :entity_type

  validates :entity_name, presence: true
  validates_uniqueness_of :entity_name, scope: :entity_type
  before_save :clean_import_key

  scope :order_by_name, -> { order_by_name }
  scope :active, -> { where('status = 1') }
  scope :is_soda, -> { where("import_key LIKE 'l.%'") }

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
  # Retrieve schedule from SODA for entity
  def retrive_schedule
    importer = SodaScheduleImport.new
    importer.run(
      team_id: import_key,
      start_datetime: DateTime.now.beginning_of_day - 30.days,
      end_datetime: DateTime.now.end_of_day,
      force_update: false
    )
    importer
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

  ##
  # Order list by entity name
  def self.order_by_name
    order('LOWER(entity_name) ASC')
  end
end
