require_relative './httpStatusCode'
require_relative './displaySingleResult'

def evaluateHttpResponse(response, singleProbeConf,is_first_run)
  # Initialize an empty string to store the logs
  logs = ""
  testPassed = true
  
  # Determine whether the response is nil, indicating an error
  if response.nil?
    # Append an error message to the logs
    logs << "[ERR] No response from #{singleProbeConf[:fullUrl]}\n"
    
    # Set the test result to failed
    testPassed = false
  else
    # Extract the status code from the response
  statusCode = response.code.to_i
  
  # Get the expected status code from the probe configuration
  expectedStatus = singleProbeConf.fetch(:expectedStatusCode, 200)
  
  # Check if the status code matches the expected status code
  if statusCode!= expectedStatus
    # Append an error message to the logs
    logs << "[ERR] HTTP code expected: #{expectedStatus}, got #{statusCode}\n"
    
    # Set the test result to failed
    testPassed = false
  else
    # Append a success message to the logs
    logs << "[OK]  HTTP code: Passed (#{expectedStatus})\n"
  end
  
  # Get the regular expression from the probe configuration
  checkRegex = singleProbeConf[:checkRegex]
  
  # Check if the response body matches the regular expression
  if checkRegex &&!response.body.match(checkRegex)
      # Append an error message to the logs
      logs << "[ERR] The Regex #{checkRegex.source} doesn't match\n"
      
      # Set the test result to failed
      testPassed = false
    else
      # Append a success message to the logs
      logs << "[OK]  Regex Check: Passed (#{checkRegex.source})\n" if checkRegex
    end
    
  end

  result = {
    logs: logs,
    conf: singleProbeConf,
    status: testPassed,
    is_first_run: is_first_run
  }

  return result
end
