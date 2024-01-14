require 'xcodeproj'

XCODE_PROJECT_PATH = "./ios/Runner.xcodeproj"

def update_build_settings(scheme_name, app_name, bundle_identifier)
  project = Xcodeproj::Project.open(XCODE_PROJECT_PATH)

  project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name.end_with?(scheme_name)
        config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_identifier
        config.build_settings['PRODUCT_NAME'] = app_name
        puts "Attempting to update build settings for configuration: #{config.name}"
      end
    end
  end

  project.save

  # Verification
  verify_build_settings(project, scheme_name, app_name, bundle_identifier)
end

def verify_build_settings(project, scheme_name, app_name, bundle_identifier)
  project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name.end_with?(scheme_name)
        if config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] == bundle_identifier &&
           config.build_settings['PRODUCT_NAME'] == app_name
          puts "Verification passed for configuration: #{config.name}"
        else
          puts "Verification failed for configuration: #{config.name}"
        end
      end
    end
  end
end

# Example usage: update_build_settings("orange", "MyApp", "com.example.myapp")
