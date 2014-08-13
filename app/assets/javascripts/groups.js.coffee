# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


groupsReady = ->

	$("#group_entity_id").select2()

$(document).ready(groupsReady)
$(document).on('page:load', groupsReady)