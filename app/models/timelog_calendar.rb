class TimelogCalendar < ActiveRecord::Base
  unloadable
  
  named_scope :by_user, lambda {|user| {:conditions => {:user_id => user.id}}}
  
end
