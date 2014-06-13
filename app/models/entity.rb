class Entity < ActiveRecord::Base
  has_many :tickets, through: :events
  has_many :groups
  has_many :events

  validates :entity_name, :logo, :presence => true
  validates_uniqueness_of :entity_name

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 0,
      :logo => '//seatsha.re/assets/images/touch-icon-ipad-retina.png'
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{entity_name}"
  end

  def self.get_by_group_id(group_id=nil)
    group = Group.find(group_id)
    entity = Entity.find(group.entity_id)
    return entity
  end

  def self.get_active_entities
    entities = Entity.where("status = 1").order('entity_name ASC')
    return entities
  end

end
