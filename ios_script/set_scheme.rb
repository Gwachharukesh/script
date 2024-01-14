require 'fileutils'

# Check if the user has provided a scheme name argument
if ARGV.empty?
  puts "Error: No scheme name provided. Usage: ruby script.rb <new_scheme_name>"
  exit 1
end

# The first argument is the new scheme name
new_scheme_name = ARGV[0]

# Define the path to the default scheme and the new scheme
default_scheme_path = './ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme'
new_scheme_path = "./ios/Runner.xcodeproj/xcshareddata/xcschemes/#{new_scheme_name}.xcscheme"

# Check if the default scheme file exists
unless File.exist?(default_scheme_path)
  puts "Error: Default scheme file not found at '#{default_scheme_path}'"
  exit 1
end

# Copy the default scheme file to the new scheme file
begin
  FileUtils.cp(default_scheme_path, new_scheme_path)
  puts "Scheme file copied successfully. New scheme '#{new_scheme_name}' created."
rescue StandardError => e
  puts "Error copying scheme file: #{e.message}"
  exit 1
end