require 'tty-box'

# Prints a formatted box with provided content and configuration
def printBox(logs, singleProbeConf, testPassed)
  # Determine the border color based on the test result
  border_color = determine_border_color(testPassed)
  
  # Prepare the content to be displayed inside the box, including the description if available
  content = prepare_content(logs, singleProbeConf)
  
  # Calculate the box height based on the actual content lines, accounting for explicit line breaks
  # and estimated line wraps.
  line_count = calculate_line_count(content)
  
  # Set the box height, adding a little margin for spacing around the content
  box_height = line_count + 4
  
  # Create and print the box with TTY::Box, using the calculated height and determined border color
  box = TTY::Box.frame(
    width: 90,
    height: box_height,
    padding: 1,
    align: :left,
    title: {top_center: singleProbeConf[:name]},
    style: {
      border: {
        type: :round,  # Use round borders for the box
        fg: border_color,  # Set the foreground color of the border
      },
    }
  ) do
    content  # The content to be displayed inside the box
  end

  print box
end

# Determines the border color based on whether the test passed, failed, or partially failed
def determine_border_color(testPassed)
  case testPassed
  when :failed
    :red
  when :partial
    :yellow
  else
    :green
  end
end

# Prepares the content to be displayed by adding a description if it exists
def prepare_content(logs, singleProbeConf)
  description = singleProbeConf[:description] ? "\e[90m#{singleProbeConf[:description]}\e[0m\n\n" : ""
  "#{description}#{logs}"
end

# Calculates the number of lines the content will occupy inside the box
def calculate_line_count(content)
  # Assumes the effective content width is 80 characters (box width of 90 - 10 for padding and borders)
  effective_width = 80
  content.lines.map { |line|
    # For each line, divide by the effective width to estimate the required number of lines after wrapping
    [1, (line.strip.length.to_f / effective_width).ceil].max
  }.sum
end
