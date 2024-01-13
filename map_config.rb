
require 'xcodeproj'

if ARGV.length != 1
  puts "Usage: ruby update_scheme.rb <scheme_name>"
  exit 1
end

scheme_name = ARGV[0]
new_release_config_name = "Release-#{scheme_name}"
project_path = './ios/Runner.xcodeproj'

# Path to the scheme file
scheme_path = "#{project_path}/xcshareddata/xcschemes/#{scheme_name}.xcscheme"

# Open the Xcode project
begin
  project = Xcodeproj::Project.open(project_path)
rescue => e
  puts "Error opening project: #{e}"
  exit 1
end

# Check if the scheme exists
unless File.exist?(scheme_path)
  puts "Error: Scheme file for '#{scheme_name}' not found."
  exit 1
end

# Load the scheme
begin
  scheme = Xcodeproj::XCScheme.new(scheme_path)
rescue => e
  puts "Error loading scheme: #{e}"
  exit 1
end

# Keep the build configuration for the 'Run' action as 'Debug'
scheme.launch_action.build_configuration = 'Debug'

# Set the build configuration for the 'Archive' action
scheme.archive_action.build_configuration = new_release_config_name

# Optionally, set the build configuration for other actions as needed
# For example, if you also want to change the configuration for the 'Profile' action:
scheme.profile_action.build_configuration = new_release_config_name

# Save the scheme back to the project
begin
  scheme.save_as(project_path, scheme_name)
  puts "Scheme '#{scheme_name}' updated: 'Run' action kept as 'Debug', 'Archive' and 'Profile' actions set to '#{new_release_config_name}'."
rescue => e
  puts "Error saving scheme: #{e}"
  exit 1
end

# Additional verification to check if the changes were correctly applied
begin
  scheme_reloaded = Xcodeproj::XCScheme.new(scheme_path)
  if scheme_reloaded.archive_action.build_configuration != new_release_config_name
    puts "Warning: Archive action configuration not set correctly in the scheme file."
  else
    puts "Verification successful: Archive action configuration is set correctly."
  end
rescue => e
  puts "Error verifying scheme changes: #{e}"
end

# require 'xcodeproj'

# if ARGV.length != 1
#   puts "Usage: ruby update_scheme.rb <scheme_name>"
#   exit 1
# end

# scheme_name = ARGV[0]
# new_release_config_name = "Release-#{scheme_name}"
# project_path = './ios/Runner.xcodeproj'

# # Path to the scheme file
# scheme_path = "#{project_path}/xcshareddata/xcschemes/#{scheme_name}.xcscheme"

# # Open the Xcode project
# project = Xcodeproj::Project.open(project_path)

# # Check if the scheme exists
# unless File.exist?(scheme_path)
#   puts "Error: Scheme file for '#{scheme_name}' not found."
#   exit 1
# end

# # Load the scheme
# scheme = Xcodeproj::XCScheme.new(scheme_path)

# # Keep the build configuration for the 'Run' action as 'Debug'
# scheme.launch_action.build_configuration = 'Debug'

# # Set the build configuration for the 'Archive' action
# scheme.archive_action.build_configuration = new_release_config_name

# # Optionally, set the build configuration for other actions as needed
# # For example, if you also want to change the configuration for the 'Profile' action:
# scheme.profile_action.build_configuration = new_release_config_name

# # Save the scheme back to the project
# scheme.save_as(project_path, scheme_name)

# puts "Scheme '#{scheme_name}' updated: 'Run' action kept as 'Debug', 'Archive' and 'Profile' actions set to '#{new_release_config_name}'."
