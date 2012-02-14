ActionController::Routing::Routes.draw do |map|
    map.resources :timelog_calendars

    map.connect 'activities.:format', :controller => 'time_entry_activities', :action => 'index', :conditions => {:method => :get}
    
end