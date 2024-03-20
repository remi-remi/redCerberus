#!/usr/bin/env ruby

require 'concurrent'
require 'json'
require 'net/http'
require 'uri'
require_relative 'httpRequester'
require_relative 'evaluateHttpResponse'

# Clear the log file at startup
File.open(HttpRequester::LOG_FILE, 'w') { |file| file.truncate(0) }

system('clear') || system('cls')  # Clear the terminal

$isFirstRun = true
$remainingProbes=0
$resetCount=0
$mutex = Mutex.new
$condition = ConditionVariable.new
$running = false

def main_loop(refresh_interval)
  loop do
    # Create and display boxes with current data
    display_boxes($isFirstRun)
    $isFirstRun = false

    sleep(refresh_interval)  # Wait before the next update
  end
end

def display_boxes(is_first_run)
  file = File.read('config.json')
  probeConfList = JSON.parse(file, symbolize_names: true)

  # Transforme les chaînes regex en objets Regexp
  probeConfList.each do |probeConf|
    probeConf[:checkRegex] = Regexp.new(probeConf[:checkRegex]) if probeConf[:checkRegex]
  end

  futures = probeConfList.map do |probeConf|
    Concurrent::Future.execute do
      response = HttpRequester.execute_http_request(probeConf[:fullUrl])
      evaluateHttpResponse(response, probeConf, is_first_run)
    end
  end

  # Attendre que tous les futures soient résolus
  futures.each(&:wait!)
end


main_loop(0)