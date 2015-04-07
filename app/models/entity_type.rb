##
# Entity Type model
class EntityType < ActiveRecord::Base
  has_many :entities
  scope :by_sort, -> { order('sort ASC') }

  ##
  # Display name for entity type
  def display_name
    "#{entity_type_name} (#{entity_type_abbreviation})"
  end
end
