class SyncCalHooks < Redmine::Hook::ViewListener
  render_on :view_my_account_contextual, :inline => "| <%= link_to(l(:label_cal_config), timelog_calendars_path) %>"

  #def controller_timelog_edit_before_save(context={ })
  #  params = context[:params]
  #  time_entry = context[:time_entry]
  #  TimelogSync::logger.debug("About to create TimeEntry #{time_entry}, params #{params}")
  #end

end


