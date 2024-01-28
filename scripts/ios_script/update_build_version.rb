require 'xcodeproj'
require 'date'

project_path = 'path/to/Runner.xcodeproj'  # Replace with the actual path to your Xcode project
target_name = 'Runner'
build_setting_name = 'FLUTTER_BUILD_SETTING'

# Get the current date in the format "YY.MM.DD"
current_date = DateTime.now.strftime("%y.%m.%d")

# Load the Xcode project
project = Xcodeproj::Project.open(project_path)

# Find the target with the specified name
target = project.targets.find { |t| t.name == target_name }

# Iterate through each build configuration for the target and update FLUTTER_BUILD_SETTING
target.build_configurations.each do |config|
  build_settings = config.build_settings
  build_settings[build_setting_name] = current_date
end

# Save the modified project
project.save

puts "Updated #{build_setting_name} in #{target_name} of #{project_path} to #{current_date}"
