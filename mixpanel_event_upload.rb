require 'mixpanel_client'
require './segment'
require 'pp'


def client
  @client ||= Mixpanel::Client.new(
    api_key: ENV["MIXPANEL_API_KEY"],
    api_secret: ENV["MIXPANEL_API_SECRET"]
  )
end

def upload(from, to)
  p "requesting #{from} #{to}"

  data = client.request(
    'export',
    from_date: from,
    to_date:   to,
  )

  data.each do |event|
    if event["properties"]["distinct_id"]
      analytics.track(
        anonymous_id: event["properties"]["distinct_id"],
        event: event["event"],
        timestamp: Time.strptime(event["properties"]["time"].to_s, "%s"),
        context: event["properties"],
        properties: event["properties"]
      )
    end
  end
end

1.upto(10).each do |month|
  from = "2015-#{month}-2"
  to = "2015-#{month + 1}-1"
  upload(from, to)
end

upload("2015-11-2", Date.today)
analytics.flush

p "All events uploaded"

