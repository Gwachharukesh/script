require 'xcodeproj'

# Constants for paths
XCODE_PROJECT_PATH = "./ios/Runner.xcodeproj"

def update_build_settings(scheme_name, app_name, bundle_identifier)
  project = Xcodeproj::Project.open(XCODE_PROJECT_PATH)

  target_name = "Runner"
  configuration_name = "Release-#{scheme_name}"

  target = project.targets.find { |t| t.name == target_name }
  unless target
    puts "Error: Target '#{target_name}' not found in the Xcode project."
    return
  end

  config = target.build_configurations.find { |c| c.name == configuration_name }
  unless config
    puts "Error: Configuration '#{configuration_name}' not found in the Xcode project for target '#{target_name}'."
    return
  end

  # Update values
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_identifier
  config.build_settings['PRODUCT_NAME'] = app_name

  # Save the project
  if project.save
    puts "Updated build settings for configuration: #{configuration_name}"
  else
    puts "Error: Failed to save the project. Please check your file permissions and project structure."
  end
end

# Example usage: update_build_settings("orange", "MyApp", "com.example.myapp")
