#!/usr/bin/env ruby

require 'xcodeproj'

# Initialize an array to store schemes with mismatched values
mismatched_schemes = []

def extract_release_scheme_values(scheme_name, bundle_identifier, app_name, mismatched_schemes)
  project_path = './ios/Runner.xcodeproj'
  puts "\nExtracting values for Release scheme: #{scheme_name}"

  project = Xcodeproj::Project.open(project_path)
  runner_target = project.targets.first
  extension_target = project.targets.find { |target| target.name == 'OneSignalNotificationServiceExtension' }

  # Set the provided bundle identifier and app name
  runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_identifier
  runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_NAME'] = app_name

  # Extract values from build settings for Runner target
  bundle_identifier_runner = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
  product_name_runner = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_NAME']
  assigned_icon = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME']
  bundle_display_name = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['PRODUCT_NAME']
  version = runner_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings['MARKETING_VERSION']

  # Extract OneSignal identifier from build settings for extension target
  extension_target_build_settings = extension_target.build_configurations.find { |config| config.name == "Release-#{scheme_name}" }.build_settings
  one_signal_identifier_extension = extension_target_build_settings['PRODUCT_BUNDLE_IDENTIFIER'] if extension_target_build_settings.key?('PRODUCT_BUNDLE_IDENTIFIER')

  # Compare values with user-provided arguments
  bundle_identifier_match = bundle_identifier_runner == bundle_identifier
  product_name_match = product_name_runner == app_name
  assigned_icon_match = assigned_icon == "AppIcon-#{scheme_name}"
  one_signal_identifier_match = one_signal_identifier_extension == "#{bundle_identifier}.OneSignalNotificationServiceExtension"

  # If there is a mismatch, add the scheme and its mismatched values to the list
  if !bundle_identifier_match || !product_name_match || !assigned_icon_match || !one_signal_identifier_match
    mismatched_schemes << {
      scheme: scheme_name,
      user_bundle_identifier: bundle_identifier,
      user_app_name: app_name,
      user_assigned_icon: "AppIcon-#{scheme_name}",
      user_one_signal_identifier: "#{bundle_identifier}.OneSignalNotificationServiceExtension",
      project_bundle_identifier: bundle_identifier_runner,
      project_app_name: product_name_runner,
      project_assigned_icon: assigned_icon,
      project_one_signal_identifier: one_signal_identifier_extension
    }

    puts "\e[31mMismatch in values!\e[0m"

    puts "\n\e[33mUser values:\e[0m"
    puts "\e[32m  Bundle Identifier: #{bundle_identifier}\e[0m"
    puts "\e[32m  App Name: #{app_name}\e[0m"
    puts "\e[32m  Assigned Icon: AppIcon-#{scheme_name}\e[0m"
    puts "\e[32m  OneSignal Identifier: #{bundle_identifier}.OneSignalNotificationServiceExtension\e[0m"

    puts "\n\e[33mProject values:\e[0m"
    puts "\e[31m  Bundle Identifier (Runner): #{bundle_identifier_runner}\e[0m"
    puts "\e[31m  App Name (Runner): #{product_name_runner}\e[0m"
    puts "\e[31m  Assigned Icon (Runner): #{assigned_icon}\e[0m"
    puts "\e[31m  OneSignal Identifier (Extension): #{one_signal_identifier_extension}\e[0m" if one_signal_identifier_extension

    puts "\n\e[33mMismatched Values:\e[0m"
    puts "\e[31m  Bundle Identifier (Runner): #{bundle_identifier_runner}\e[0m" unless bundle_identifier_match
    puts "\e[31m  App Name (Runner): #{product_name_runner}\e[0m" unless product_name_match
    puts "\e[31m  Assigned Icon (Runner): #{assigned_icon}\e[0m" unless assigned_icon_match
    puts "\e[31m  OneSignal Identifier: #{one_signal_identifier_extension}\e[0m" unless one_signal_identifier_match
  else
    puts "\n\e[32mScheme Name: #{scheme_name} - OK\e[0m"
    puts "\nBundle Display Name (Runner): #{bundle_display_name}"
    puts "Version (Runner): #{version}"
  end
end

# Function to display mismatched schemes at the end
def display_mismatched_schemes(mismatched_schemes)
  puts "\nMismatched Schemes:"
  mismatched_schemes.each do |scheme|
    puts "\n\e[31mScheme: #{scheme[:scheme]} - Mismatch\e[0m"
    puts "\e[33mUser values:\e[0m"
    puts "\e[32m  Bundle Identifier: #{scheme[:user_bundle_identifier]}\e[0m" if scheme[:user_bundle_identifier] != scheme[:project_bundle_identifier]
    puts "\e[32m  App Name: #{scheme[:user_app_name]}\e[0m" if scheme[:user_app_name] != scheme[:project_app_name]
    puts "\e[32m  Assigned Icon: #{scheme[:user_assigned_icon]}\e[0m" if scheme[:user_assigned_icon] != scheme[:project_assigned_icon]
    puts "\e[32m  OneSignal Identifier: #{scheme[:user_one_signal_identifier]}\e[0m" if scheme[:user_one_signal_identifier] != scheme[:project_one_signal_identifier]
    puts "\e[33mProject values:\e[0m"
    puts "\e[31m  Bundle Identifier (Runner): #{scheme[:project_bundle_identifier]}\e[0m"
    puts "\e[31m  App Name (Runner): #{scheme[:project_app_name]}\e[0m"
    puts "\e[31m  Assigned Icon (Runner): #{scheme[:project_assigned_icon]}\e[0m"
    puts "\e[31m  OneSignal Identifier (Extension): #{scheme[:project_one_signal_identifier]}\e[0m" if scheme[:project_one_signal_identifier]
  end
end

# Get scheme name, bundle identifier, and app name from command line arguments
scheme_name = ARGV[0]
bundle_identifier = ARGV[1]
app_name = ARGV[2]

# Check if the user provided scheme, bundle identifier, and app name
if scheme_name.nil? || bundle_identifier.nil? || app_name.nil?
  puts "Please provide scheme name, bundle identifier, and app name as arguments."
else
  extract_release_scheme_values(scheme_name, bundle_identifier, app_name, mismatched_schemes)
end

# Display mismatched schemes at the end
display_mismatched_schemes(mismatched_schemes)
