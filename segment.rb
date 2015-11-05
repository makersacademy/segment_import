require 'dotenv'
require 'segment/analytics'
Dotenv.load

def analytics
  @analytics ||= Segment::Analytics.new({
    write_key: ENV["SEGMENT_WRITE_KEY"],
    on_error: Proc.new { |status, msg| raise msg }
  })
end
