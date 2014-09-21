# Global
seatshareReady = ->

  # Navbar group switching
  $('#group_switcher select#group_selector').change (e) ->
  	window.location = '/groups/' + $(this).val()

  # Confirm actions
  $('a.confirm').click () ->
  	return window.confirm 'Are you sure?'

  # Tooltips
  $('a[data-toggle="tooltip"], span[data-toggle="tooltip"], div[data-toggle="tooltip"]').tooltip()

$(document).ready(seatshareReady)
$(document).on('page:load', seatshareReady)