#!/usr/bin/env ruby
require 'timeout'
require 'fileutils'

file_path = './lib/config/flavor/flavor_config.dart'
enum_data = {}
selected_schemes = []

def display_flavors(file_path, enum_data)
  in_enum = false
  current_enum = nil
  scheme_count = 0

  File.foreach(file_path) do |line|
    in_enum = true if line.include?('enum EnvironmentType {')
    in_enum = false if in_enum && line.include?('};')

    if in_enum && line.include?('(')
      current_enum = line.split('(').first.strip
      next if line.strip.start_with?('const', 'EnvironmentType', 'log', 'final String', 'required')

      enum_data[current_enum] = {}
      scheme_count += 1
      puts "\e[32m#{scheme_count}. #{current_enum}\e[0m"
    end
  end
end

def validate_user_input(scheme_count)
  user_input = nil

  begin
    Timeout::timeout(25) do
      print "Choose schemes by entering their numbers separated by spaces: "
      user_input = gets.chomp.gsub(/\s+/, ' ').split.map(&:to_i)
    end
  rescue Timeout::Error
    user_input = (1..scheme_count).to_a
    puts "\nNo selection made within 25 seconds. All schemes have been selected."
  end

  validate_and_replace_invalid_inputs(user_input, scheme_count)
end

def validate_and_replace_invalid_inputs(user_input, scheme_count)
  invalid_inputs = user_input.select { |input| input <= 0 || input > scheme_count }

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

  user_input
end

def display_selected_schemes(selected_schemes)
  puts "\e[32mSelected Schemes:\e[0m"
  selected_schemes.each do |scheme|
    puts "\e[32m#{scheme[:number]}. #{scheme[:name]}\e[0m"
  end
end

def build_archive(scheme)
  xcode_workspace_path = "./ios/Runner.xcworkspace"
  build_directory = "./ios/build"
  pod_install_script = "./ios_script/pod_install.rb"
  delete_build_phase_script = "./ios_script/delete_build_phase.rb"
  archive_output_directory = "#{build_directory}/archives"

  system("ruby #{pod_install_script}")
  system("ruby #{delete_build_phase_script}")

  FileUtils.mkdir_p(archive_output_directory)

  puts "Building archive for scheme: #{scheme}"

  build_command = "xcodebuild -workspace #{xcode_workspace_path} -scheme #{scheme} -archivePath #{archive_output_directory}/#{scheme}.xcarchive archive"
  system(build_command)

  if $?.success?
    puts "Archive build successful. Archive is located at: #{archive_output_directory}/#{scheme}.xcarchive"
  else
    puts "Error: Archive build failed for scheme: #{scheme}"
    exit 1
  end

  open_command = "open #{archive_output_directory}/#{scheme}.xcarchive"
  system(open_command)
end

begin
  display_flavors(file_path, enum_data)
  
  loop do
    user_input = validate_user_input(enum_data.keys.length)
    
    user_input.each do |input|
      selected_schemes << { number: input, name: enum_data.keys[input - 1] }
    end
    
    break
  end

  display_selected_schemes(selected_schemes)

  # Build archives for selected schemes
  selected_schemes.each do |scheme|
    build_archive(scheme[:name])
  end

rescue => e
  puts "An error occurred: #{e.message}"
end
