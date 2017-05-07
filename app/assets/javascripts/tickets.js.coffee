ticketsReady = ->

	# Ticket alias toggle
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
   
   # Ticket toggles
	$('.tickets_select_all').click ->
		$('input:checkbox').prop('checked',true)
	$('.tickets_select_none').click ->
		$('input:checkbox').prop('checked',false)

	true

$(document).ready(ticketsReady)
$(document).on('turbolinks:load', ticketsReady)
