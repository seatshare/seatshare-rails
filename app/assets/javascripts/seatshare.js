var SITE_ROOT = '';

// Navbar group switching
$(document).ready(function() {
	if (!$('#group_switcher').length) {
		return;
	}

	$('#group_switcher select#group_id').change(function(e) {
		window.location = '/groups/' + $(this).val();
	});
});

// Confirm actions
$('a.confirm').click(function() {
	return window.confirm('Are you sure?');
});

// Tooltips
$('a[data-toggle="tooltip"], span[data-toggle="tooltip"], div[data-toggle="tooltip"]').tooltip();

// Ticket alias toggle
$(document).ready(function() {
	if (!$('select[name="assigned"]').length) {
		return;
	}
	$('select[name="assigned"]').change(function() {
		var self = this;
		if ($(self).data('current') != $(self).val()) {
			$('#alias_control').hide();
			$('select[name="alias"]').val(0);
		} else {
			$('#alias_control').show();
		}
	});
});

// Mobile Safari in standalone mode
if(("standalone" in window.navigator) && window.navigator.standalone){

	// If you want to prevent remote links in standalone web apps opening Mobile Safari, change 'remotes' to true
	var noddy, remotes = false;
	
	document.addEventListener('click', function(event) {
		
		noddy = event.target;
		
		// Bubble up until we hit link or top HTML element. Warning: BODY element is not compulsory so better to stop on HTML
		while(noddy.nodeName !== "A" && noddy.nodeName !== "HTML") {
			noddy = noddy.parentNode;
		}
		
		if('href' in noddy && noddy.href.indexOf('http') !== -1 && (noddy.href.indexOf(document.location.host) !== -1 || remotes))
		{
			event.preventDefault();
			document.location.href = noddy.href;
		}
	
	},false);
}
