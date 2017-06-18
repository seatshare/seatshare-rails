$(document).on 'turbolinks:load ready', ->
  # Navbar group switching
  $('#group_switcher select#group_selector').change (e) ->
    window.location = '/groups/' + $(this).val()

  # Confirm actions
  $('a.confirm').click () ->
    return window.confirm 'Are you sure?'

  # Tooltips
  $('a[data-toggle="tooltip"], span[data-toggle="tooltip"], div[data-toggle="tooltip"], button[data-toggle="tooltip"]').tooltip()

  # Clipboard.js
  clipboard = new Clipboard('.btn-clipboard')
  clipboard.on 'success', (e) ->
    $(e.trigger).attr('title', 'Copied!').tooltip('show')
    $(e.trigger).on 'hidden.bs.tooltip', () ->
      $(e.trigger).tooltip('destroy')
  
  # Responsive Tables
  $('.table-responsive').on 'show.bs.dropdown', () ->
    $('.table-responsive').css "overflow", "inherit"
  $('.table-responsive').on 'hide.bs.dropdown', () ->
    $('.table-responsive').css "overflow", "auto"

$(document).on 'page:before-change', ->
  clipboard = new Clipboard('.btn-clipboard')
  clipboard.destroy()
