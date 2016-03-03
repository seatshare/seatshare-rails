$(document).on 'page:load ready', ->
  # Navbar group switching
  $('#group_switcher select#group_selector').change (e) ->
    window.location = '/groups/' + $(this).val()

  # Confirm actions
  $('a.confirm').click () ->
    return window.confirm 'Are you sure?'

  # Tooltips
  $('a[data-toggle="tooltip"], span[data-toggle="tooltip"], div[data-toggle="tooltip"], button[data-toggle="tooltip"]').tooltip()

  # Zeroclipboard
  clip = new ZeroClipboard($("button.zeroclipboard"))
  
  # Responsive Tables
  $('.table-responsive').on 'show.bs.dropdown', () ->
    $('.table-responsive').css "overflow", "inherit"
  $('.table-responsive').on 'hide.bs.dropdown', () ->
    $('.table-responsive').css "overflow", "auto"

$(document).on 'page:before-change', ->
  ZeroClipboard.destroy()
