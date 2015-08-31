require 'json'
require_relative 'lib/system_helper'

begin
  torrent = JSON.parse(ARGV[0] || '')
rescue JSON::ParserError
  raise ArgumentError, 'Torrent has invalid JSON format'
end

if open_url(torrent['magnetLink']).failed?
  open_url(torrent['url'])
end