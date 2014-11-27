# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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
