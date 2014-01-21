WebsocketRails::EventMap.describe do
  namespace :status do
    subscribe :changed, "status#changed"
  end
end
