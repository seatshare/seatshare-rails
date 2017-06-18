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
$(document).on('turbolinks:load', publicTeamsReady)