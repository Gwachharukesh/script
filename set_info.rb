require 'xcodeproj'
require 'plist'
require 'fileutils'

# Constants for paths
XCODE_PROJECT_PATH = "./ios/Runner.xcodeproj" # Set the path to your Xcode project
PLIST_PATH = "./ios/Runner/Info.plist" # Set the path to your Info.plist

def update_info_plist(scheme_name, app_name, bundle_identifier)
  puts "Updating Info.plist for scheme: #{scheme_name}..."
  
  begin
    plist = Plist.parse_xml(PLIST_PATH)

    plist['CFBundleName'] = app_name
    plist['CFBundleIdentifier'] = bundle_identifier
    plist['CFBundleDisplayName'] = app_name

    build_number = plist['CFBundleVersion'].to_i
    plist['CFBundleVersion'] = build_number + 1

    Plist::Emit.save_plist(plist, PLIST_PATH)

    sleep 1 # Wait for the filesystem to sync

    updated_plist = Plist.parse_xml(PLIST_PATH)
    if updated_plist['CFBundleName'] == app_name &&
       updated_plist['CFBundleIdentifier'] == bundle_identifier &&
       updated_plist['CFBundleDisplayName'] == app_name
      puts "Info.plist updated successfully for scheme: #{scheme_name}."
    else
      puts "Failed to update Info.plist for scheme: #{scheme_name}. Values in the file do not match the expected ones."
    end
  rescue StandardError => e
    puts "An error occurred while updating Info.plist: #{e.message}"
  end
end

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

if ARGV.length < 2
  puts "Usage: ruby update_project.rb <scheme_name> <app_name> [bundle_identifier]"
  exit
end

scheme_name, app_name, bundle_identifier = ARGV
bundle_identifier ||= "dynamic.school.#{scheme_name}" # Default pattern for bundle identifier

unless File.exist?(PLIST_PATH)
  puts "Info.plist not found at #{PLIST_PATH}"
  exit 1
end

puts "Backing up original Info.plist..."
FileUtils.cp(PLIST_PATH, "#{PLIST_PATH}.backup")

# Update the build settings and Info.plist
update_build_settings(scheme_name, app_name, bundle_identifier)
update_info_plist(scheme_name, app_name, bundle_identifier)
