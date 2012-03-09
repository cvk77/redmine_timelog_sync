require 'redmine'
require 'dispatcher'
require 'patches/spent_time_field.rb'
require 'hooks.rb'

require_dependency 'principal'
require_dependency 'user'

require_dependency 'timelog_sync'
require_dependency 'patches/time_entry_patches.rb'

Dispatcher.to_prepare :redmine_timelog_sync do
    require_dependency 'time_entry'
    TimeEntry.send(:include, TimelogSync::Patches::TimeEntryPatch) unless TimeEntry.included_modules.include? TimelogSync::Patches::TimeEntryPatch
end

Redmine::Plugin.register :redmine_timelog_sync do
  name 'Redmine Timelog Sync plugin'
  author 'Christoph von Krüchten'
  description 'Sync efforts to an CalDAV server in Timelog''s format'
  version '0.2'
  url 'http://team.webrunners.de/redmine'
  author_url 'http://www.webrunners.de'
end

Query.class_eval do
    include QueryPatch
end


