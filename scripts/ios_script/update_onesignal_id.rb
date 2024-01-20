require 'xcodeproj'

# Default path to the Xcode project
default_project_path = './ios/Runner.xcodeproj'

# User inputs as command-line arguments
scheme = ARGV[0]
user_bundle_identifier = ARGV[1]

# Default bundle identifier with the provided scheme
default_bundle_identifier = "dynamic.school.#{scheme}.OneSignalNotificationServiceExtension"

# Use user-provided bundle identifier or the default
bundle_identifier = user_bundle_identifier.nil? || user_bundle_identifier.empty? ? default_bundle_identifier : user_bundle_identifier

# Load the Xcode project
project = Xcodeproj::Project.open(default_project_path)

# Configure Runner target settings
runner_target = project.targets.find { |target| target.name == 'Runner' }
if runner_target
  runner_target.build_configurations.each do |config|
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
  end
end

# Configure OneSignalNotificationServiceExtension target settings for "Release-scheme"
extension_target = project.targets.find { |target| target.name == 'OneSignalNotificationServiceExtension' }
if extension_target
  release_scheme_config = extension_target.build_configurations.find { |config| config.name == "Release-#{scheme}" }
  if release_scheme_config
    release_scheme_config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
    release_scheme_config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_identifier
  end
end

# Save the changes to the Xcode project
project.save

puts 'Xcode project configuration completed successfully.'
