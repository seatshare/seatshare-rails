# -*- coding: utf-8 -*-
entity_type_id = EntityType.find_by_entity_type_abbreviation('MLS').id
Entity.create([
  {
    entity_name: 'Chicago Fire', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.986'
  },
  {
    entity_name: 'Columbus Crew', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.991'
  },
  {
    entity_name: 'D.C. United', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.999'
  },
  {
    entity_name: 'Houston Dynamo', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.997'
  },
  {
    entity_name: 'Montreal Impact', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.ZR2'
  },
  {
    entity_name: 'New England Revolution', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.995'
  },
  {
    entity_name: 'New York Red Bulls', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.996'
  },
  {
    entity_name: 'Philadelphia Union', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.ZP6'
  },
  {
    entity_name: 'Sporting Kansas City', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.993'
  },
  {
    entity_name: 'Toronto FC', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.981'
  },
  {
    entity_name: 'Chivas USA', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.984'
  },
  {
    entity_name: 'Colorado Rapids', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.990'
  },
  {
    entity_name: 'FC Dallas', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.992'
  },
  {
    entity_name: 'LA Galaxy', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.994'
  },
  {
    entity_name: 'Portland Timbers', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.ZP8'
  },
  {
    entity_name: 'Real Salt Lake', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.985'
  },
  {
    entity_name: 'San Jose Earthquakes', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.979'
  },
  {
    entity_name: 'Seattle Sounders FC', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.AA0'
  },
  {
    entity_name: 'Vancouver Whitecaps FC', entity_type_id: entity_type_id, status: 1, import_key: 'l.mlsnet.com-t.ZP9'
  },
  {
    entity_name: 'New York City FC', entity_type_id: entity_type_id, status: 0, import_key: 'mls-new-york-city-fc'
  },
  {
    entity_name: 'Orlando City SC', entity_type_id: entity_type_id, status: 0, import_key: 'mls-orlando-city-fc'
  }
])
