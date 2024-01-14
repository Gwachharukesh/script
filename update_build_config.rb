require 'xcodeproj'

# Constants for paths
XCODE_PROJECT_PATH = "./ios/Runner.xcodeproj" # Set the path to your Xcode project

def update_build_settings(scheme_name, app_name, bundle_identifier)
  project = Xcodeproj::Project.open(XCODE_PROJECT_PATH)

  project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name.end_with?(scheme_name)
        config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_identifier
        config.build_settings['PRODUCT_NAME'] = app_name
        puts "Updated build settings for configuration: #{config.name}"
      end
    end
  end

  project.save
end
