loginReady = ->

  $('.toggle-password').click ->
    if $(this).hasClass 'enabled'
      $('input[name="user[password]"]').attr 'type', 'password'
      $(this).removeClass 'enabled'
    else
      $('input[name="user[password]"]').attr 'type', 'text'
      $(this).addClass 'enabled'

$(document).ready(loginReady)
$(document).on('page:load', loginReady)
