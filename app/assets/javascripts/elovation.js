$(function(){

	var $availability = $('#availability')
	var $status = $('#status')

	if (!$availability.length){
		return;
	}

function sort_items(){
	var $items = $availability.children('li').get();
	$items.sort(function(a, b) {
		 var $a = $(a), $b = $(b)
	   return $a.data('statusKey').toUpperCase().localeCompare($b.data('statusKey').toUpperCase());
	})

	$.each($items, function(idx, itm) { 
		$availability.append(itm); 
	});
}

window.sort_items = sort_items;
	var dispatcher = new WebSocketRails(location.host + '/websocket')
		, channel 	 = dispatcher.subscribe('availability')
		, audio 		 = new Audio('/assets/sf_token.mp3')
		, status_codes = {
				online: 'online',
				ready: 'ready',
				offline: 'offline'
			}

	$status.on('change', function(){
		dispatcher.trigger('status.change', { status: $status.val() })
	})

	channel.bind('updated', function(data) {
		var output = [], play = false
		for (var status in data) {
			output.push('<li data-status-key="'+data[status].status+data[status].name+'" class="status-list-item status-'+ data[status].status + '">')
			output.push('<img src="' + data[status].gravatar_url + '"/>')
			output.push('<span>' + data[status].name + '</span>')
			output.push('</li>')

			if (data[status].status == 'available' && data[status].previous_status != 'available')
				play = true
		}

		$availability.html(output.join(''))
		sort_items();
		console.log(data, $availability, output.join(''))
	});

	dispatcher.on_open = function(data){
		dispatcher.trigger('status.change', { 
			status: status_codes.online 
		})
	}

});