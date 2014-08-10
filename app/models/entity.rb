class Entity < ActiveRecord::Base
  has_many :tickets, through: :events
  has_many :groups
  has_many :events

  validates :entity_name, :presence => true
  validates_uniqueness_of :entity_name

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 0,
      :import_key => generate_import_key(attributes)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{entity_name} (#{entity_type})"
  end

  def self.get_by_group_id(group_id=nil)
    group = Group.find(group_id)
    Entity.find(group.entity_id)
  end

  def self.get_by_entity_type(entity_type=nil)
    Entity.where("entity_type = '#{entity_type}'").order('entity_name ASC')
  end

  def self.get_active_entities
    Entity.where("status = 1").order('entity_type ASC, entity_name ASC')
  end

  private

  def generate_import_key(attributes)
    "#{attributes[:entity_type]}: #{attributes[:entity_name]}".parameterize
  end

end
