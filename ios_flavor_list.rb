#!/usr/bin/env ruby
require 'timeout'
# Path to the Dart file containing enum definitions
file_path = './lib/config/flavor/flavor_config.dart'
enum_data = {}
selected_schemes = []
# Display a list of flavors
puts "\e[32mAvailable Schemes:\e[0m"

begin
  in_enum = false
  current_enum = nil
  scheme_count = 0

  # Iterate through each line of the Dart file
  File.foreach(file_path) do |line|
    # Check if the line contains the start of the enum definition
    in_enum = true if line.include?('enum EnvironmentType {')
    in_enum = false if in_enum && line.include?('};')

    # If inside the enum and the line contains '(' (enum value)
    if in_enum && line.include?('(')
      # Extract the enum value
      current_enum = line.split('(').first.strip
      # Skip certain lines (e.g., const, EnvironmentType, log, final String, required)
      next if line.strip.start_with?('const', 'EnvironmentType', 'log', 'final String', 'required')
      # Initialize a hash for the current enum
      enum_data[current_enum] = {}
      # Increment scheme_count for numbering schemes
      scheme_count += 1
      # Print the enum value with a number for user selection
      puts "\e[32m#{scheme_count}. #{current_enum}\e[0m"
    end
  end

  # Validate user input
  loop do
    user_input = nil
    begin
      # Set a timeout of 25 seconds for user input
      puts "Select within 25 seconds otherwise all schemes will be selected."
      Timeout::timeout(25) do
        print "Choose schemes by entering their numbers separated by spaces: "
        user_input = gets.chomp.gsub(/\s+/, ' ').split.map(&:to_i)
      end
    rescue Timeout::Error
      # If the user doesn't make a selection within 25 seconds, select all schemes
      user_input = (1..scheme_count).to_a
      puts "\nNo selection made within 25 seconds. All schemes have been selected."
    end

    # Filter out invalid inputs
    invalid_inputs = user_input.select { |input| input <= 0 || input > scheme_count }

    # If there are invalid inputs, prompt the user to replace them
    unless invalid_inputs.empty?
      invalid_inputs.each do |invalid_input|
        replacement = nil
        until replacement&.between?(1, scheme_count)
          puts "\e[31mInvalid selection #{invalid_input}. Please enter a valid number.\e[0m"
          print "Replace #{invalid_input} with: "
          replacement = gets.chomp.to_i
        end
        user_input[user_input.index(invalid_input)] = replacement
      end
    end

    # Add the validated user inputs to the selected schemes list
    user_input.each do |input|
      selected_schemes << { number: input, name: enum_data.keys[input - 1] }
    end
    break
  end

  # Display the selected schemes
  puts "\e[32mSelected Schemes:\e[0m"
  selected_schemes.each do |scheme|
    puts "\e[32m#{scheme[:number]}. #{scheme[:name]}\e[0m"
  end

rescue => e
  # Handle any errors that occur during script execution
  puts "An error occurred: #{e.message}"
end
