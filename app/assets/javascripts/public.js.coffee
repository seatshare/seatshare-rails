# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

##
# Team Page Effects
publicTeamsReady = ->
  c = 0
  location_words = ['field','court','ice','track']
  $('.location_word').css
    'display': 'inline-block'
    'width': '190px'
    'text-align': 'center'
    'background-color': 'rgba(255, 255, 255, 0.1)'
    'border-radius': '10px'

  wordLoop = ->
    $('.location_word').delay(6000).fadeTo 900, 0, () ->
      $(this).text(location_words[++c%location_words.length]).fadeTo(300,1,wordLoop)
  wordLoop()

$(document).ready(publicTeamsReady)
$(document).on('page:load', publicTeamsReady)