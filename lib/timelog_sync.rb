module TimelogSync

    require 'caldav.rb'
    require 'uri'

    def TimelogSync.logger
        RAILS_DEFAULT_LOGGER
    end
    
    class TimeLogEntry

        def initialize(model)
            @uid = URI.escape("redmine:" + User.current.name + ":" + model.id.to_s)
            @client = find_client(model)
            @project = model.project.name
            @task = model.activity.name
            @description = model.comments
            @start = model.spent_on.to_datetime
            @end = @start + model.hours.hours #sic!
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
            c = CalDAV::Connection.new("https://team.webrunners.de/calendar/caldav.php/#{tc.username}/#{tc.name}", tc.username, tc.password)
            c.create self.to_event
        end

        def delete
            tc = load_config
            return if tc.nil?
            c = CalDAV::Connection.new("https://team.webrunners.de/calendar/caldav.php/#{tc.username}/#{tc.name}", tc.username, tc.password)
            c.remove @uid
        end

        private

        def load_config()
            tc = TimelogCalendar.by_user(User.current).first
            if tc.nil?
                TimelogSync::logger.error("No calendar data for user: " + User.current)
                return
            end
            return tc
        end

        def find_client(project)
            project.custom_field_values.each do |field|
                if field.custom_field.name == "Client"
                    return field.value
                end
            end
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