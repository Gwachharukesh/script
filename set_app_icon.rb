require 'xcodeproj'

# Set the iOS project path relative to the Flutter project root
xcode_project_path = "./ios"

# Main execution starts here
if ARGV.length != 1
  puts "Usage: ruby set_app_icon_set_name.rb <schemename>"
  exit
end

schemename = ARGV[0]

# Correct the path to the Xcode project file
xcode_project_file = "#{xcode_project_path}/Runner.xcodeproj"

unless File.exist?(xcode_project_file)
  puts "Xcode project file not found at #{xcode_project_file}"
  exit 1
end

project = Xcodeproj::Project.open(xcode_project_file)

# Update build settings in the project for the specific target and configuration
target_name = "Runner"
configuration_name = "Release-#{schemename}"

target = project.targets.find { |t| t.name == target_name }

unless target
  puts "Target #{target_name} not found in the Xcode project."
  exit 1
end

config = target.build_configurations.find { |c| c.name == configuration_name }

unless config
  puts "Configuration #{configuration_name} not found in the Xcode project for target #{target_name}."
  exit 1
end

# Set Primary App Icon Set Name in Release-schemename configuration
config.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = "AppIcon-#{schemename}"

project.save

puts "Primary App Icon Set Name set successfully for #{configuration_name} configuration in the Runner target."
