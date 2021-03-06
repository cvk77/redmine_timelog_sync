module TimelogSync

    require 'caldav.rb'
    require 'uri'

    def TimelogSync.logger
        RAILS_DEFAULT_LOGGER
    end
    
    class TimeLogEntry

        # @param model [TimeEntry]
        def initialize(model)
            @uid = URI.escape("redmine:#{User.current.login}:#{model.id.to_s}")
            @client = model.project.custom_value_for(ProjectCustomField.find_by_name("Client"))
            @project = model.project.name
            @task = model.activity.name
            comment = unless model.comments.blank? then model.comments else model.issue.subject end
            @description = "\##{model.issue.id}: #{comment}"

            # see Feature #2488
            if model.spent_on == Date.today
                # Set entries for today to the correct time (i.e. now - time spent)
                @start = DateTime.now - model.hours.hours #sic!
                @end = DateTime.now
            else
                # Entry for another day - set to 0:00 to avoid false information
                @start = model.spent_on.to_datetime
                @end = @start + model.hours.hours #sic!
            end

        end

        def to_s
            to_event.to_s
        end

        def to_event
            e = CalDAV::Event.new
            e.uid = @uid
            e.dtstart = @start
            e.dtend = @end
            e.summary = @project + ":" + @task
            e.description = @description
            e.uri = URI.escape("timelog://start/?status=(null)&client=#{@client}&creator=&category=#{@task}&project=#{@project}")
            return e
        end

        def upload
            tc = load_config
            return if tc.nil?
            TimelogSync::logger.info("Uploading event to #{tc.name}")
            c = CalDAV::Connection.new("/#{tc.username}/#{tc.name}", tc.username, tc.password)
            c.create self.to_event
        end

        def delete
            tc = load_config
            return if tc.nil?
            c = CalDAV::Connection.new("/#{tc.username}/#{tc.name}", tc.username, tc.password)
            c.remove @uid
        end

        private

        def load_config
            tc = TimelogCalendar.by_user(User.current).first
            if tc.nil?
                TimelogSync::logger.info("Not sending to server. No calendar data for user: " + User.current.to_s)
                return
            end
            return tc
        end

    end


    def TimelogSync.create(model)
        logger.debug("Creation hook")
        e = TimeLogEntry.new(model)
        e.upload
        logger.debug(e.to_s)
    end

    def TimelogSync.update(model)
        logger.debug("Update hook")
        e = TimeLogEntry.new(model)
        e.upload
        logger.debug(e.to_s)
    end

    def TimelogSync.delete(model)
        logger.debug("Deletion hook")
        e = TimeLogEntry.new(model)
        e.delete
        logger.debug(e.to_s)
    end
    
end