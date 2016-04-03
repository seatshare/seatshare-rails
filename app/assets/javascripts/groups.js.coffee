groupsReady = ->

  # Create Group
  if $("#group_entity_id").length > 0
    $("#group_entity_id").select2({
      theme: 'bootstrap',
      placeholder: "Click to search our more than 2,800 available teams",
      allowClear: true
    })

  # Change Placeholder Text
  $("#group_entity_id").on "select2-selected", ->
    data = $("#group_entity_id").select2 "data"
    suffixes = ['Fans', 'Super Fans', 'Supporters', 'Backers', 'Crew', 'Pride']
    suffix = suffixes[Math.floor(Math.random() * suffixes.length)];
    $('#group_group_name').attr 'placeholder', "e.g. #{data.text} #{suffix}"

  # Calendar
  group_id = $('#group_selector').val()
  if $("#sidebar_calendar").length > 0
    $.get "/groups/#{group_id}/events_feed", (result) ->
      $("#sidebar_calendar").clndr
        template: "<div class='clndr-controls'>" +
          "  <div class='clndr-control-button'><span class='clndr-previous-button'><span class='fa fa-chevron-left'></span></span></div>" +
          "  <div class='month'><%= month %> <%= year %></div>" +
          "  <div class='clndr-control-button rightalign'><span class='clndr-next-button'><span class='fa fa-chevron-right'></span></span></div>" +
          "</div>" +
          "<table class='clndr-table' border='0' cellspacing='0' cellpadding='0'>" +
          "<thead><tr class='header-days'><% for(var i = 0; i < daysOfTheWeek.length; i++) { %><td class='header-day'><%= daysOfTheWeek[i] %></td><% } %></tr></thead>" +
          "<tbody>" +
          "  <% for(var i = 0; i < numberOfRows; i++){ %><tr><% for(var j = 0; j < 7; j++){ %><% var d = j + i * 7; %>" +
          "  <td class='<%= days[d].classes %>' data-events='<%= JSON.stringify(days[d].events) %>'><div class='day-contents'><%= days[d].day %></div></td>" +
          "  <% } %></tr><% } %>" +
          "</tbody>" +
          "</table>"
        daysOfTheWeek: [
          "S"
          "M"
          "T"
          "W"
          "T"
          "F"
          "S"
        ]
        numberOfRows: 5
        events: result
        clickEvents:
          click: (target) ->
            return false  if not _.isObject(target.events) or _.isEmpty(target.events[0])
            window.location = target.events[0].url
            return
        doneRendering: () ->
          $('#sidebar_calendar td.day.event').each (i, day) ->
            events = $(day).data('events')
            # Add ticket indicator
            for e in events
              if e.ticket_stats.held > 0
                notation = $('<div class="has_tickets" />').tooltip({
                  title: "You have #{e.ticket_stats.held} ticket(s) for this event."
                });
                $(day).prepend(notation)
            # Add tooltip
            $('div', day).tooltip
              title: () ->
                output = []
                for e in events
                  output.push "#{e.title}"
                output.join("; ")

        showAdjacentMonths: true
        adjacentDaysChangeMonth: true
      return

$(document).ready(groupsReady)
$(document).on('page:load', groupsReady)
