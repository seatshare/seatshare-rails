# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Ticket alias toggle
ready = ->

	ticket_user_id_field = $('select[name="ticket[user_id]"]')

	ticket_alias_toggle = ->
		current_user = parseInt(ticket_user_id_field.data('current'),10)
		ticket_user = parseInt(ticket_user_id_field.val(),10)

		if current_user != ticket_user || ticket_user = 0
			$('#alias_control').hide()
		else
			$('#alias_control').show()
		true

	# Run toggle on init
	do ticket_alias_toggle

	# Bind change event
	ticket_user_id_field.change ticket_alias_toggle

	true

$(document).ready(ready)
$(document).on('page:load', ready)