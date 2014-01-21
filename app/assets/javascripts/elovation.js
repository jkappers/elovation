$(function(){

	var dispatcher = new WebSocketRails(location.host + '/websocket')
		, channel 	 = dispatcher.subscribe('availability')
		, audio 		 = new Audio('/assets/sf_token.mp3')
		, status_codes = {
				online: 'online',
				ready: 'ready',
				offline: 'offline'
			}

	var $availability = $('#availability')
	var $status = $('#status')

	$status.on('change', function(){
		dispatcher.trigger('status.change', { status: $status.val() })
	})

	channel.bind('updated', function(data) {
		var output = [], play = false
		for (var status in data) {
			output.push('<li class="list-group-item">')
			output.push(data[status].name)
			output.push(' | ')
			output.push(data[status].status)
			output.push('</li>')

			if (data[status].status == 'available' && data[status].previous_status != 'available')
				play = true
		}

		$availability.html(output.join(''))
		if (play){
			audio.play();
		}
		console.log(data, $availability, output.join(''))
	});

	dispatcher.on_open = function(data){
		dispatcher.trigger('status.change', { 
			status: status_codes.online 
		})
	}

});