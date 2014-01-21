class StatusController < WebsocketRails::BaseController
  after_filter :publish_availability

  def connected
    set_status("online")
  end

  def disconnected
    set_status("offline")
  end

  def change
    set_status(message[:status]) 
  end

  private

  def set_status(status)    
    if status != "offline"
      if store[key].nil?
        store[key] = {
              id: current_player.id,
            name: current_player.name,
          status: status,
          previous_status: nil
        }
      else
        store[key][:previous_status] = store[key][:status]
        store[key][:status] = status
      end
    else
      store.delete(key)
    end   
  end

  def store
   controller_store[:players] ||= {}
  end

  def key
    current_player.id
  end

  def publish_availability
    WebsocketRails[:availability].trigger(:updated, store)    
  end

end