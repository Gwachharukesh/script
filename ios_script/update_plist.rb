require 'xcodeproj'
require 'plist'

# Check if the correct number of arguments are provided
unless ARGV.length == 1
  puts "Usage: #{$PROGRAM_NAME} <scheme_name>"
  exit
end

scheme_name = ARGV[0]

# Path to your .xcodeproj file
project_path = './ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Finding the target named 'Runner'
target = project.targets.find { |t| t.name == 'Runner' }

unless target
  puts "Target 'Runner' not found."
  exit
end

# Build configuration name pattern
config_name_pattern = "Release-#{scheme_name}"

# Finding the build configurations matching the pattern
matching_config = target.build_configurations.find do |config|
  config.name == config_name_pattern
end

unless matching_config
  puts "No build configuration found matching '#{config_name_pattern}'."
  exit
end

# Retrieve build settings
product_name = matching_config.build_settings['PRODUCT_NAME']
bundle_identifier = matching_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
# Add other build settings retrievals here if needed

# Path to Info.plist
info_plist_path = target.build_configurations.first.build_settings['INFOPLIST_FILE']
info_plist_full_path = File.join(File.dirname(project_path), info_plist_path)
info_plist = Plist.parse_xml(info_plist_full_path)

# Update Info.plist values
info_plist['CFBundleName'] = product_name
info_plist['CFBundleIdentifier'] = bundle_identifier
info_plist['CFBundleShortVersionString'] = product_name # Assuming version is same as product name
info_plist['CFBundleDisplayName'] = product_name

# Save changes to Info.plist
info_plist.save_plist(info_plist_full_path)

puts "Info.plist updated for configuration '#{config_name_pattern}' in target 'Runner'."
