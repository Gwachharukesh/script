#!/usr/bin/env ruby

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

# Display a list of flavors with index and an option to select all
puts "Please choose flavors (separated by space) or type 'all' to select all:"
enum_data.keys.each_with_index do |enum_name, index|
  puts "#{index + 1}. #{enum_name}"
end

# Get user input
print "Enter your choices: "
input = gets.chomp

# Handle selection of all enums
selected_enums = if input.downcase == 'all'
  enum_data.keys
else
  input.split.map(&:to_i).map { |index| enum_data.keys[index - 1] }.compact
end

# Store the list of selected enums
selected_enum_list = []

selected_enums.each do |enum_name|
  selected_enum_list << enum_name unless enum_name.nil?
  puts "Selected Flavor: #{enum_name}"
  enum_data[enum_name].each { |key, value| puts "  #{key}: #{value}" unless value.nil? }
end
