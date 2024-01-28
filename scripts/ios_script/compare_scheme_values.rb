#!/usr/bin/env ruby

require 'xcodeproj'

def extract_release_scheme_values(scheme_name)
  project_path = './ios/Runner.xcodeproj'
  puts "Extracting values for Release scheme: #{scheme_name}"

  project = Xcodeproj::Project.open(project_path)
  runner_target = project.targets.first
  extension_target = project.targets.find { |target| target.name == 'OneSignalNotificationServiceExtension' }

  # Extract values from build settings for Runner target
  bundle_identifier = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
  product_name = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_NAME']
  assigned_icon = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME']
  bundle_display_name = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_NAME']
  version = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['MARKETING_VERSION']

  # Extract OneSignal identifier from build settings for extension target
  one_signal_identifier_extension = extension_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_BUNDLE_IDENTIFIER']

  puts "Bundle Identifier (Runner): #{bundle_identifier}"
  puts "Product Name (Runner): #{product_name}"
  puts "Assigned Icon (Runner): #{assigned_icon}"
  puts "OneSignal Identifier (Extension): #{one_signal_identifier_extension}"
  puts "Bundle Display Name (Runner): #{bundle_display_name}"
  puts "Version (Runner): #{version}"
end

# Get scheme name from command line arguments
scheme_name = ARGV[0]

# Check if the user provided a scheme
if scheme_name.nil?
  puts "Please provide a scheme name as an argument."
else
  extract_release_scheme_values(scheme_name)
end
