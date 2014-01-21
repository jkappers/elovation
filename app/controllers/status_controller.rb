class StatusController < WebsocketRails::BaseController
  def initialize_session    
    controller_store[:status] = {}
  end

  def changed
		trigger_success(:success => true)
	end
end