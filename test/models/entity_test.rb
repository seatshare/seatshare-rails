require 'test_helper'

##
# Entity test
class EntityTest < ActiveSupport::TestCase
  ##
  # Setup test
  def setup
    Time.zone = 'Central Time (US & Canada)'

    SeatGeek::Connection.client_id = 'a_test_client_id'
    stub_request(
      :get,
      'https://api.seatgeek.com/2/events'\
        '?per_page=500&performers.slug=nashville-predators&venue.id=2195'
    ).to_return(
      status: 200,
      body: File.new(
        'test/fixtures/seatgeek/events-nashville-predators.json'
      ).read
    )
    stub_request(
      :get,
      'https://api.seatgeek.com/2/performers'\
        '?slug=nashville-predators'
    ).to_return(
      status: 200,
      body: File.new(
        'test/fixtures/seatgeek/performers-nashville-predators.json'
      ).read
    )
    super
  end

  test 'new entity has attributes' do
    entity = Entity.new(
      entity_name: 'Nashville Sportsball (Inactive)',
      entity_type_id: 5
    )
    entity.save!

    assert entity.entity_name?
    refute entity.status
  end

  test 'fixture entity has attributes' do
    entity = Entity.find(1)

    assert_equal 'Nashville Predators', entity.entity_name
    assert entity.status
  end

  test 'gets entity by group id' do
    entity = Group.find(2).entity

    assert_equal 5, entity.id
    assert_equal 'Nashville Sportsball', entity.entity_name
    assert_equal 'Sportsball League (SBL)', entity.entity_type.display_name
    assert entity.status
  end

  test 'get all active entities' do
    entities = Entity.active

    assert_equal 5, entities.count, 'count of fixture entities matches'
    assert_equal 'Entity', entities[0].class.to_s, 'class of fixture matches'
    assert entities[0].entity_name?, 'fixture entity name is set'
  end

  test 'import from SeatGeek' do
    entity = Entity.find(1)
    records = entity.seatgeek_import

    assert_equal 29, records.count
    assert_equal(
      'Florida Panthers at Nashville Predators',
      records.first.event_name
    )
    assert_equal 'Bridgestone Arena (Nashville, TN)', records.first.description
    assert_equal(
      '2015-12-03 19:00:00 -0600',
      records.first.start_time.to_s
    )
  end

  test 'import from SeatGeek without proper import key' do
    entity = Entity.find(2)
    response = entity.seatgeek_import

    assert_equal 'Not a SeatGeek entity', response
  end

  test 'gets a default avatar' do
    entity = Entity.find(1)
    default_avatar = entity.default_avatar

    assert_match(
      %r{^/assets/entity_types/nhl-group-medium-missing-},
      default_avatar
    )
  end

  test 'gets SeatGeek schedule data' do
    entity = Entity.find(1)
    schedule = entity.seatgeek_schedule

    assert_equal 29, schedule['events'].count
    assert_equal(
      'Florida Panthers at Nashville Predators',
      schedule['events'].first['title']
    )
  end

  test 'gets SeatGeek performer data' do
    entity = Entity.find(1)
    performer = entity.seatgeek_performer

    assert_equal 'Nashville Predators', performer['name']
    assert_equal(
      'https://chairnerd.global.ssl.fastly.net/images/performers-landscape/'\
      'nashville-predators-4acd2d/2136/huge.jpg',
      performer['image']
    )
  end
end
