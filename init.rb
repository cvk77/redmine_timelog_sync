require 'redmine'
require 'dispatcher'

require_dependency 'principal'
require_dependency 'user'

require_dependency 'timelog_sync'
require_dependency 'patches/time_entry_signals.rb'

Dispatcher.to_prepare :redmine_timelog_sync do
    require_dependency 'time_entry'
    TimeEntry.send(:include, TimelogSync::Patches::TimeEntryPatch) unless TimeEntry.included_modules.include? TimelogSync::Patches::TimeEntryPatch
end

Redmine::Plugin.register :redmine_timelog_sync do
  name 'Redmine Timelog Sync plugin'
  author 'Christoph von Krüchten'
  description 'Sync efforts to an CalDAV server in Timelog''s format'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://www.webrunners.de'
end

class SyncCalHooks < Redmine::Hook::ViewListener
    render_on :view_my_account_contextual, :inline => "| <%= link_to(l(:label_cal_config), timelog_calendars_path) %>"
end

