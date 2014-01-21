WebsocketRails::EventMap.describe do
  namespace :status do
    subscribe :changed
  end
end
