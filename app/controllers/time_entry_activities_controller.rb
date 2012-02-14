class TimeEntryActivitiesController < ApplicationController
unloadable

    def index
        respond_to do | format |
            format.api  {
                @offset, @limit = api_offset_and_limit
                @activities = TimeEntryActivity.all(:offset => @offset, :limit => @limit, :order => 'name')
                @activity_count = TimeEntryActivity.count
            }
        end

    end
end
