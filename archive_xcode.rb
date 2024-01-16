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

# Define the path to the pod install script
pod_install_script = "./ios_script/pod_install.rb"

# Define the path to the delete build phase script
delete_build_phase_script = "./ios_script/delete_build_phase.rb"

# Run the pod install script
puts "Running pod install script..."
system("ruby #{pod_install_script}")

# Run the delete build phase script
puts "Running delete build phase script..."
system("ruby #{delete_build_phase_script}")

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



# # Build Archive Script for Flutter iOS Project in Xcode

# # Check if the scheme argument is provided
# if ARGV.empty?
#   puts "Error: Please provide the scheme to build."
#   puts "Usage: ruby build_archive.rb <scheme>"
#   exit 1
# end

# # Assign the scheme from the command line argument
# scheme = ARGV[0]

# # Define the path to the Xcode workspace
# xcode_workspace_path = "./ios/Runner.xcworkspace"

# # Define the build directory
# build_directory = "./ios/build"

# "./ios_script/pod_install.rb"
# "./ios_script/delete_build_phase.rb"

# # Define the output directory for the archive
# archive_output_directory = "#{build_directory}/archives"

# # Create the output directory and its parent directories if they don't exist
# require 'fileutils'
# FileUtils.mkdir_p(archive_output_directory)

# # Build the archive using xcodebuild command
# puts "Building archive for scheme: #{scheme}"

# # You can customize the build settings as needed
# build_command = "xcodebuild -workspace #{xcode_workspace_path} -scheme #{scheme} -archivePath #{archive_output_directory}/#{scheme}.xcarchive archive"

# # Execute the build command
# system(build_command)

# # Check the build result
# if $?.success?
#   puts "Archive build successful. Archive is located at: #{archive_output_directory}/#{scheme}.xcarchive"
# else
#   puts "Error: Archive build failed."
#   exit 1
# end

# # Open Xcode and load the archive
# open_command = "open #{archive_output_directory}/#{scheme}.xcarchive"
# system(open_command)
