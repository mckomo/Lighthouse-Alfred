require 'json'
require 'faraday'

module Lighthouse

	class Repository
		
		API_URL = 'http://light-tower.cloudapp.net/api/v1/'

    def initialize(connection)
      @connection = connection
    end

    def find(query)

      if query.length < 3
        raise ArgumentError, 'Enter at least 3 characters'
      end

      response = request_api('torrents', q: query)

      unless response.status == 200
        raise RuntimeError, 'Torrent repository internal error'
      end

      JSON.parse(response.body)

    end

    private

    def request_api(endpoint, params = {})
      begin
        @connection.get(endpoint, params) do  |req|
          req.options.open_timeout = 3
        end
      rescue Faraday::ConnectionFailed
        raise RuntimeError, 'Torrent repository is down'
      end
    end

    class << self

      protected :new

      def connect(connection = nil)
        new(connection || default_connection)
      end

      private

      def default_connection
        ::Faraday.new(url: API_URL)
      end

		end

	end
end