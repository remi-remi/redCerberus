require 'net/http'
require 'uri'

module HttpRequester
  LOG_FILE = 'http_errors.log'.freeze

  def self.execute_http_request(url)
    uri = URI(url)

    response = nil

    open_timeout = 5
    read_timeout = 5

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', open_timeout: open_timeout, read_timeout: read_timeout) do |http|
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
    end

    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
      response
    else
      response # Returns the response even in case of errors to allow for further evaluation
    end
  rescue => e
    log_error("HTTP Request Failed: #{e.message}, URL: #{url}")
    nil # Returns nil only in case of real exceptions, not for HTTP error codes
  end

  def self.log_error(message)
    File.open(LOG_FILE, 'a') do |file|
      file.puts("#{Time.now}: #{message}")
    end
  end
end
