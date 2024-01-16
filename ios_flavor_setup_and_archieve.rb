#!/usr/bin/env ruby
require 'timeout'
require 'open3'

# Path to the Dart file containing enum definitions
file_path = './lib/config/flavor/flavor_config.dart'
enum_data = {}

# Read the Dart file and extract enum names and values
begin
  in_enum = false
  current_enum = nil

  # Process each line of the file
  File.foreach(file_path) do |line|
    # Detect the start and end of the enum block
    in_enum = true if line.include?('enum EnvironmentType {')
    in_enum = false if in_enum && line.include?('};')

    # Extract enum names and their values
    if in_enum && line.include?('(')
      current_enum = line.split('(').first.strip
      next if line.strip.start_with?('const', 'EnvironmentType', 'log', 'final String', 'required')
      enum_data[current_enum] = { urlName: nil, companyCode: nil, appName: nil, companyName: nil }
    end

    # Assign values to the current enum
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

# Display a list of flavors
puts "Please choose flavors (enter numbers separated by space, or leave blank to select all):"
enum_data.keys.each_with_index { |enum_name, index| puts "#{index + 1}. #{enum_name}" }

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

# Determine selected enums based on user input
selected_schemes = if input.nil? || input.strip.empty?
  enum_data.keys
else
  input.split.map(&:to_i).map { |index| enum_data.keys[index - 1] }.compact
end

# Function to run a script and check its success
def run_script(script_name)
  puts "Running script: #{script_name}"
  stdout_str, stderr_str, status = Open3.capture3("ruby #{script_name}")
  puts stdout_str # Print standard output
  unless status.success?
    puts "Error running #{script_name}: #{stderr_str}" # Print error if any
    exit 1
  end
  puts "#{script_name} completed successfully."
end

# Iterate over the selected enums and run scripts for each
selected_schemes.each do |scheme_name|
  # Retrieve the appName for the current scheme
  app_name = enum_data[scheme_name][:appName] || "DefaultAppName"

  # Print the current scheme_name and app_name
  puts "\nProcessing Scheme: #{scheme_name}"
  puts "App Name: #{app_name}"

  # Construct the various identifiers using scheme_name and app_name
  bundle_identifier = "dynamic.school.#{scheme_name}" 
  build_mode = "release"
  app_icon_name = "Appicon-#{scheme_name}"
  bundle_display_name = "#{app_name}-#{build_mode}"
  onesignal_bundle_identifier = "com.example.#{scheme_name}.OneSignalNotificationServiceExtension"

  # Define the scripts to be run for the current scheme
  scripts = [
    # "reset.rb",
    "./ios_script/launcher_icon.rb \"#{scheme_name}\"",
    "./ios_script/set_scheme.rb \"#{scheme_name}\"",
    "./ios_script/config_scheme.rb \"#{scheme_name}\"",
    "./ios_script/map_config.rb \"#{scheme_name}\"",
    "./ios_script/update_build_config.rb \"#{scheme_name}\" \"#{app_name}\" \"#{bundle_identifier}\"",
    "./ios_script/update_plist.rb \"#{scheme_name}\"",
    "./ios_script/set_app_icon.rb \"#{scheme_name}\"",
    "./ios_script/update_onesignal_id.rb \"#{scheme_name}\" \"#{onesignal_bundle_identifier}\"",
    # "./ios_script/pod_install.rb"
  ]

  # Run each script in sequence for the selected scheme
  scripts.each { |script| run_script(script) }
end

puts "All scripts executed successfully."

