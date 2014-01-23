WebsocketRails::EventMap.describe do
	subscribe :client_connected, 		"status#connected"
	subscribe :client_disconnected, "status#disconnected"

  namespace :status do
  	subscribe :change, "status#change"
  end
end
