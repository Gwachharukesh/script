require 'xcodeproj'

scheme_name = 'Cat'
new_release_config_name = 'Release-Cat'
project_path = './Runner.xcodeproj'

# Path to the scheme file
scheme_path = "#{project_path}/xcshareddata/xcschemes/#{scheme_name}.xcscheme"

# Open the Xcode project
project = Xcodeproj::Project.open(project_path)

# Check if the scheme exists
unless File.exist?(scheme_path)
  puts "Error: Scheme file for '#{scheme_name}' not found."
  exit 1
end

# Load the scheme
scheme = Xcodeproj::XCScheme.new(scheme_path)

# Keep the build configuration for the 'Run' action as 'Debug'
scheme.launch_action.build_configuration = 'Debug'

# Set the build configuration for the 'Archive' action to 'Release-Cat'
scheme.archive_action.build_configuration = new_release_config_name

# Optionally, set the build configuration for other actions as needed
# For example, if you also want to change the configuration for the 'Profile' action:
scheme.profile_action.build_configuration = new_release_config_name

# Save the scheme back to the project
scheme.save_as(project_path, scheme_name)

puts "Scheme '#{scheme_name}' updated: 'Run' action kept as 'Debug', 'Archive' and 'Profile' actions set to '#{new_release_config_name}'."
