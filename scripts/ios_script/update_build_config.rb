require 'xcodeproj'

# Check if the correct number of arguments are provided
unless ARGV.length == 3
  puts "Usage: #{$PROGRAM_NAME} <scheme_name> <product_name> <bundle_identifier>"
  exit
end

scheme_name = ARGV[0]
product_name = ARGV[1]
bundle_identifier = ARGV[2]

# Print the arguments for 3 seconds
puts "Received Arguments:"
puts "Scheme Name: #{scheme_name}"
puts "Product Name: #{product_name}"
puts "Bundle Identifier: #{bundle_identifier}"
sleep(3)
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
matching_configs = target.build_configurations.select do |config|
  config.name == config_name_pattern
end

if matching_configs.empty?
  puts "No build configurations found matching '#{config_name_pattern}'."
  exit
end

# Updating build settings
matching_configs.each do |config|
  config.build_settings['PRODUCT_NAME'] = product_name
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_identifier
  # Add other build settings modifications here if needed
end

# Save the project with modified build settings
project.save

puts "Build settings updated for configurations matching '#{config_name_pattern}' in target 'Runner'."
