class Entity < ActiveRecord::Base
  has_many :tickets, through: :events
  has_many :groups
  has_many :events

  validates :entity_name, :presence => true
  validates_uniqueness_of :entity_name, scope: :entity_type

  scope :order_by_name, -> { order('LOWER(entity_type) ASC, LOWER(entity_name) ASC') }
  scope :active, -> { where('status = 1') }

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 0,
      :import_key => generate_import_key(attributes)
    }.merge(attributes)

    # Prevent empty import key
    if attributes[:import_key] === ''
      attr_with_defaults[:import_key] = generate_import_key(attributes)
    end

    super(attr_with_defaults)
  end

  def display_name
    "#{entity_name} (#{entity_type})"
  end

  private

  def generate_import_key(attributes)
    "#{attributes[:entity_type]}: #{attributes[:entity_name]}".parameterize
  end

end
