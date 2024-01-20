#!/usr/bin/env ruby
require 'timeout'

file_path = './lib/config/flavor/flavor_config.dart'
enum_data = {}

# Read the Dart file and extract enum names and values
begin
  in_enum = false
  current_enum = nil

  File.foreach(file_path) do |line|
    if line.include?('enum EnvironmentType {')
      in_enum = true
      next
    end

    if in_enum && line.include?('};')
      in_enum = false
      break
    end

    if in_enum && line.include?('(') && !line.strip.start_with?('const', 'EnvironmentType', 'log', 'final String', 'required')
      current_enum = line.split('(').first.strip
      enum_data[current_enum] = {
        urlName: nil,
        companyCode: nil,
        appName: nil,
        companyName: nil
      }
    end

    if current_enum
      enum_data[current_enum][:urlName] = line.split("'")[1] if line.include?('urlName:')
      enum_data[current_enum][:companyCode] = line.split(':')[1].split(',').first.strip if line.include?('companyCode:')
      enum_data[current_enum][:appName] = line.split("'")[1] if line.include?('appName:')
      enum_data[current_enum][:companyName] = line.split("'")[1] if line.include?('companyName:')
    end
  end
rescue => e
  puts "An error occurred: #{e.message}"
  exit 1
end

# Display a list of flavors with index
puts "Please choose flavors (enter numbers separated by space):"
enum_data.keys.each_with_index do |enum_name, index|
  puts "#{index + 1}. #{enum_name}"
end

# Function to get user input with a timeout
def get_user_input(timeout_sec)
  input = nil
  begin
    Timeout.timeout(timeout_sec) do
      print "Enter your choices within #{timeout_sec} seconds: "
      input = gets.chomp
    end
  rescue Timeout::Error
    puts "\nNo input received. Proceeding with default selection."
  end
  input
end

# Get user input or default to all if no input within 10 seconds
input = get_user_input(10)

# Handle selection based on user input or default to all if no input
selected_schemes = if input.nil? || input.strip.empty?
  enum_data
else
  input.split.map(&:to_i).map { |index| enum_data.keys[index - 1] }.compact.to_h { |key| [key, enum_data[key]] }
end

# Print the selected enums and their details or just the names in a grid if all are selected
if selected_schemes.keys == enum_data.keys
  puts "All Flavors Selected:"
  enum_data.keys.each_slice(3) { |slice| puts slice.join('  |  ') } # Adjust the number in each_slice for your grid preference
else
  selected_schemes.each do |enum_name, values|
    puts "Selected Flavor: #{enum_name}"
    values.each { |key, value| puts "  #{key}: #{value}" unless value.nil? }
  end
end

# selected_schemes now contains the selected enums along with their values

