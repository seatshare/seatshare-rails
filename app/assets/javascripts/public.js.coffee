# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

publicReady = ->

	self.run = ->

		# Collect the needed data for the total cost
		numberOfGames = parseFloat $('#number_of_games').val()
		numberOfSeats = parseFloat $('#number_of_seats').val()
		costPerSeat = parseFloat $('#cost_per_seat').val()

		# Calculate total cost if valid data
		if !isNaN(numberOfGames) && !isNaN(numberOfSeats) && !isNaN(costPerSeat)
			totalCost = parseFloat(numberOfGames * numberOfSeats * costPerSeat)
		else
			totalCost = 0.00

		# Update the total cost field
		$('#total_cost').val(totalCost)

		# For each row, calculate share of totalCost if valid data

		# Calculate remaining share if investment less than total cost

	# Only invoke if calculator route
	if $('form#calculator').length > 0
		
		# Calculate on input key-up and button click
		$('input.ticket_details').keyup -> self.run()
		$('#calculate_totals').click -> self.run()

		# Add a row
		$('#add_row').click ->
			index = $('table#people tbody tr').length+1
			template = '<tr data-person="'+index+'">'
			template += '  <td><input class="form-control" id="person_name_'+index+'" /></td>'
			template += '  <td>'
			template += '    <div class="input-group">'
			template += '     <span class="input-group-addon">$</span>'
			template += '     <input class="form-control" id="person_investment_'+index+'" value="0.00" />'
			template += '    </div>'
			template += '  </td>'
			template += '  <td class="text-center" id="person_seats_'+index+'">0</td>'
			template += '  <td class="text-right"><a id="person_delete_'+index+'" class="btn btn-danger delete_row"><span class="glyphicon glyphicon-trash"></span></a></td>'
			template += '</tr>'
			$('table#people tbody tr:last').after(template);

		# Remove a row
		$('table#people tbody tr').on 'click', 'a.delete_row', ->
			if $('table#people tbody tr').length == 1
				$.growl("Cannot delete last row.", { type: 'danger' });
				return
			$(this).closest('tr').remove()


$(document).ready(publicReady)
$(document).on('page:load', publicReady)