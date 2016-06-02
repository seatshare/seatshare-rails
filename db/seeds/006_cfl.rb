# -*- coding: utf-8 -*-
entity_type_id = EntityType.find_by_entity_type_abbreviation('CFL').id
Entity.create([
  {
    entity_name: 'Hamilton Tiger-Cats', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.4'
  },
  {
    entity_name: 'Montreal Alouettes', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.5'
  },
  {
    entity_name: 'Ottawa Redblacks', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.6'
  },
  {
    entity_name: 'Toronto Argonauts', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.8'
  },
  {
    entity_name: 'BC Lions', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.1'
  },
  {
    entity_name: 'Calgary Stampeders', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.2'
  },
  {
    entity_name: 'Edmonton Eskimos', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.3'
  },
  {
    entity_name: 'Saskatchewan Roughriders', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.7'
  },
  {
    entity_name: 'Winnipeg Blue Bombers', entity_type_id: entity_type_id, status: true, import_key: 'l.cfl.ca-t.9'
  }
])
