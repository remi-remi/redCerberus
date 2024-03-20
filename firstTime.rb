#!/usr/bin/env ruby

require 'tty-box'

# Define a helper method to print a section with a title and content
def print_section(title, content)
  box = TTY::Box.frame(
    align: :left,
    padding: 1,
    title: {top_center: title},
    style: {
      fg: :bright_white,
      border: {
        fg: :bright_red,
      },
    }
  ) do
    content
  end

  print box
  puts "\n0. Back to Main Menu"
end

# Define the welcome method that displays a welcome message and main menu
def welcome
  content = "Hi, my name is Cerberus, don't be shy, I don't bite.\n" +
            "I'm here to help you monitor your websites and services with ease.\n" +
            "Let's walk through how to use me.\n\n"
  print_section("Welcome", content)
  main_menu
end

# Define the main_menu method that displays the main menu and handles user input
def main_menu
  content = "1. Introduction to Cerberus\n" +
            "2. Setting up your first probe\n" +
            "3. Understanding the results\n" +
            "4. Customizing Cerberus\n" +
            "5. Exit\n\n" +
            "Please select an option by entering a number:"
  print_section("Main Menu", content)

  case gets.chomp
  when "1"
    introduction
  when "2"
    setup_probe
  when "3"
    understand_results
  when "4"
    customize
  when "5"
    puts "Goodbye! Feel free to run me again if you need a refresher."
    exit
  else
    puts "Please enter a valid option."
    main_menu
  end
end

# Define the introduction method that displays an introduction to Cerberus
def introduction
  content = "Cerberus is a monitoring tool designed to help you keep an eye on your websites and services.\n" +
            "You can configure Cerberus to make HTTP requests to specified URLs and check the responses against expected outcomes.\n"
  print_section("Introduction to Cerberus", content)
  back_to_main_menu
end

# Define the setup_probe method that displays instructions for setting up a probe
def setup_probe
  content = "To set up a probe, you'll need to create a configuration file in JSON format.\n" +
            "This file should specify the URL to check, the expected HTTP status code, and optionally, a regex pattern to match in the response body.\n"
  print_section("Setting up your first probe", content)
  back_to_main_menu
end

# Define the understand_results method that displays instructions for understanding the results
def understand_results
  content = "After running Cerberus, you'll see results displayed in colored boxes.\n" +
            "Green boxes indicate success, yellow boxes indicate partial failures, and red boxes indicate failures.\n"
  print_section("Understanding the results", content)
  back_to_main_menu
end

# Define the customize method that displays instructions for customizing Cerberus
def customize
  content = "If you're comfortable with Ruby, you can customize Cerberus by modifying the code.\n" +
            "For example, you can change the tty-box styles in 'displaySingleResult.rb' to style the app to your liking.\n"
  print_section("Customizing Cerberus", content)
  back_to_main_menu
end

# Define the back_to_main_menu method that returns to the main menu and handles user input
def back_to_main_menu
  case gets.chomp
  when "0"
    main_menu
  else
    puts "Returning to the main menu..."
    main_menu
  end
end

# Call the welcome method to display the welcome message and main menu
welcome