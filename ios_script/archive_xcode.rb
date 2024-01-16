# Build Archive Script for Flutter iOS Project in Xcode

# Check if the scheme argument is provided
if ARGV.empty?
  puts "Error: Please provide the scheme to build."
  puts "Usage: ruby build_archive.rb <scheme>"
  exit 1
end

# Assign the scheme from the command line argument
scheme = ARGV[0]

# Define the path to the Xcode workspace
xcode_workspace_path = "./ios/Runner.xcworkspace"

# Define the build directory
build_directory = "./ios/build"

# Define the output directory for the archive
archive_output_directory = "#{build_directory}/archives"

# Create the output directory and its parent directories if they don't exist
require 'fileutils'
FileUtils.mkdir_p(archive_output_directory)

# Build the archive using xcodebuild command
puts "Building archive for scheme: #{scheme}"

# You can customize the build settings as needed
build_command = "xcodebuild -workspace #{xcode_workspace_path} -scheme #{scheme} -archivePath #{archive_output_directory}/#{scheme}.xcarchive archive"

# Execute the build command
system(build_command)

# Check the build result
if $?.success?
  puts "Archive build successful. Archive is located at: #{archive_output_directory}/#{scheme}.xcarchive"
else
  puts "Error: Archive build failed."
  exit 1
end

# Open Xcode and load the archive
open_command = "open #{archive_output_directory}/#{scheme}.xcarchive"
system(open_command)
