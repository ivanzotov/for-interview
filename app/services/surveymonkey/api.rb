module Surveymonkey
  module Api
    HOST = "api.surveymonkey.net"
    SCHEME = "https"
    VERSION = "v3"
    BASE_URL = "#{SCHEME}://#{HOST}/#{VERSION}"

    RESPONSE_DETAILS = "#{BASE_URL}/surveys/%{survey_id}/responses/%{id}/details"

    def self.authorized
      Faraday.new do |connection|
        connection.use Faraday::Request::Authorization, :Bearer, ENV['SURVEYMONKEY_ACCESS_TOKEN']
        connection.use Faraday::Response::RaiseError
      end
    end
  end
end