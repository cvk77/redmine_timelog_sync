module CalDAV

    DATEFORMAT = "%Y%m%dT%H%M%S"
    PRODID = "-//TimeLogSync//webrunners.de//"
    BASE_URL = "https://team.webrunners.de/calendar/caldav.php"

    require 'date'
    require 'net/http'
    require 'net/https'
    require 'uuidtools'

    class Event
        attr_accessor :uid, :uri, :created, :dtstart, :dtend, :lastmodified, :summary, :description

        def initialize()
            @dtstart = DateTime.now
            @dtend = DateTime.now
            @uid = UUIDTools::UUID.random_create
        end

        def to_s
            [
                "BEGIN:VCALENDAR",
                "PRODID:#{CalDAV::PRODID}",
                "VERSION:2.0",
                "BEGIN:VEVENT",
                "CREATED:#{DateTime.now.strftime(DATEFORMAT)}Z",
                "DTSTAMP:#{DateTime.now.strftime(DATEFORMAT)}Z",
                "UID:#{@uid}",
                "SUMMARY:#{@summary}",
                "URL;VALUE=URI:#{@uri}",
                "DTSTART;TZID=Europe/Berlin:#{@dtstart.strftime(DATEFORMAT)}",
                "DTEND;TZID=Europe/Berlin:#{@dtend.strftime(DATEFORMAT)}",
                "SEQUENCE:0",
                "DESCRIPTION:#{@description}",
                "END:VEVENT",
                "END:VCALENDAR"
            ].join("\n")
        end
    end

    class Connection

        attr_accessor :url, :user, :password

        public

            def initialize(url, user, password )
               @url = BASE_URL + url
               @user = user
               @password = password
            end

            def retrieve uid = nil
                url = @url
                url = url + "/" + uid + ".ics" if not uid.nil?
                get(url).body
            end

            def create event
                HTTP_put(@url + "/" + event.uid + ".ics", event.to_s)
                event.uid
            end

            def remove uid
                HTTP_delete(@url + "/" + uid + ".ics")
            end

        private

            def HTTP_connect(url)
                url = URI.parse(url)
                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = url.scheme == "https"
                return http, url
            end

            def HTTP_get(url)
                http, url = HTTP_connect(url)
                request = Net::HTTP::Get.new(url.path)
                request.basic_auth @user, @password
                http.start {|http| http.request(request) }
            end

            def HTTP_put(url, body, content_type = 'text/calendar')
                http, url = HTTP_connect(url)
                request = Net::HTTP::Put.new(url.path)
                request.basic_auth @user, @password
                request['Content-Type'] = content_type
                request.body = body
                http.start {|http| http.request(request) }
            end

            def HTTP_delete(url)
                http, url = HTTP_connect(url)
                request = Net::HTTP::Delete.new(url.path)
                request.basic_auth @user, @password
                http.start {|http| http.request(request) }
            end

    end

end