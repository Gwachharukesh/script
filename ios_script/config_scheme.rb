require 'xcodeproj'

# Check if the user has provided a scheme name argument
if ARGV.empty?
  puts "Error: No scheme name provided. Usage: ruby script.rb <new_scheme_suffix>"
  exit 1
end

# The first argument is the new scheme suffix
new_scheme_suffix = ARGV[0]

# Set the project path directly to the Runner.xcodeproj in the current directory
project_path = './ios/Runner.xcodeproj'

# Open the Xcode project
project = Xcodeproj::Project.open(project_path)

# New configuration name
new_config_name = "Release-#{new_scheme_suffix}"

# Find and duplicate the 'Release' configuration for each target
project.targets.each do |target|
  release_config = target.build_configurations.find { |config| config.name == 'Release' }
  if release_config
    # Duplicate the 'Release' configuration
    duplicated_config = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
    duplicated_config.name = new_config_name
    duplicated_config.build_settings = release_config.build_settings.clone
    duplicated_config.base_configuration_reference = release_config.base_configuration_reference

    # Add the duplicated configuration to the target
    target.build_configuration_list.build_configurations << duplicated_config
  end
end

# Find and duplicate the 'Release' configuration for the project itself
release_config = project.build_configuration_list.build_configurations.find { |config| config.name == 'Release' }
if release_config
  # Duplicate the 'Release' configuration
  duplicated_config = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)
  duplicated_config.name = new_config_name
  duplicated_config.build_settings = release_config.build_settings.clone
  duplicated_config.base_configuration_reference = release_config.base_configuration_reference

  # Add the duplicated configuration to the project
  project.build_configuration_list.build_configurations << duplicated_config
end

# Save the project file
project.save

puts "New build configuration '#{new_config_name}' created based on 'Release' configuration."



# require 'xcodeproj'

# # Check if the user has provided a scheme name argument
# if ARGV.empty?
#   puts "Error: No scheme name provided. Usage: ruby script.rb <new_scheme_suffix>"
#   exit 1
# end

# # The first argument is the new scheme suffix
# new_scheme_suffix = ARGV[0]

# # Set the project path directly to the Runner.xcodeproj in the current directory
# project_path = './Runner.xcodeproj'

# # Open the Xcode project
# project = Xcodeproj::Project.open(project_path)

# # New configuration name
# new_config_name = "Release-#{new_scheme_suffix}"

# # Duplicate 'Release' configuration for all targets
# project.targets.each do |target|
#   release_config = target.build_configurations.find { |config| config.name == 'Release' }
#   if release_config
#     # Duplicate the 'Release' configuration
#     duplicated_config = release_config.dup
#     duplicated_config.name = new_config_name
    
#     # Add the duplicated configuration to the target
#     target.build_configuration_list.build_configurations << duplicated_config
#   end
# end

# # Duplicate 'Release' configuration for the project itself
# project.build_configuration_list.build_configurations.each do |config|
#   if config.name == 'Release'
#     # Duplicate the 'Release' configuration
#     duplicated_config = config.dup
#     duplicated_config.name = new_config_name
    
#     # Add the duplicated configuration to the project
#     project.build_configuration_list.build_configurations << duplicated_config
#   end
# end

# # Save the project file
# project.save

# puts "New build configuration '#{new_config_name}' created based on 'Release' configuration."
