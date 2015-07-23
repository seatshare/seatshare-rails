require 'test_helper'

##
# Entity test
class EntityTest < ActiveSupport::TestCase
  test 'new entity has attributes' do
    entity = Entity.new(
      entity_name: 'Nashville Sportsball (Inactive)',
      entity_type_id: 5
    )
    entity.save!

    assert entity.entity_name?, 'Name for entity is set'
    assert entity.status == 0, 'Status for entity is inactive'
  end

  test 'fixture entity has attributes' do
    entity = Entity.find(1)

    assert entity.entity_name == 'Nashville Predators', 'Name for entity is set'
    assert entity.status == 1, 'Status for entity is inactive'
  end

  test 'gets entity by group ID' do
    entity = Group.find(2).entity

    assert entity.id == 5, 'fixture entity ID matches'
    assert entity.entity_name == 'Nashville Sportsball', 'fixture name matches'
    assert entity.entity_type.display_name == 'Sportsball League (SBL)'
    assert entity.status == 1, 'fixture entity is active'
  end

  test 'get all active entities' do
    entities = Entity.active

    assert entities.count == 5, 'count of fixture entities matches'
    assert entities[0].class.to_s == 'Entity', 'class of fixture entity matches'
    assert entities[0].entity_name?, 'fixture entity name is set'
  end
end
