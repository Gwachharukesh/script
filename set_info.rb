require 'xcodeproj'
require 'plist'
require 'fileutils'

# Set the iOS project path relative to the Flutter project root
xcode_project_path = "./ios"

# Set the path to Info.plist relative to the Flutter project root
info_plist_path = "./ios/Runner/Info.plist"

def update_info_plist(plist_path, scheme_flavor_name, display_name)
  plist = Plist.parse_xml(plist_path)

  # Update bundle name, bundle identifier, and display name
  plist['CFBundleName'] = scheme_flavor_name
  plist['CFBundleIdentifier'] = "dynamic.school.#{scheme_flavor_name}"
  plist['CFBundleDisplayName'] = display_name

  # Auto-increment the build number
  build_number = plist['CFBundleVersion'].to_i
  plist['CFBundleVersion'] = build_number + 1

  # Save changes to Info.plist
  Plist::Emit.save_plist(plist, plist_path)
end

def update_build_settings(project_path, scheme_flavor_name, display_name)
  # Correct the path to the Xcode project file
  xcode_project_file = "#{project_path}/Runner.xcodeproj"
  unless File.exist?(xcode_project_file)
    puts "Xcode project file not found at #{xcode_project_file}"
    exit 1
  end

  project = Xcodeproj::Project.open(xcode_project_file)

  # Update build settings in the project for the specific target
  project.targets.each do |target|
    target.build_configurations.each do |config|
      # Check if the configuration name matches the scheme name
      if config.name == "Release-#{scheme_flavor_name}" || config.name == "Debug-#{scheme_flavor_name}"
        config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = "dynamic.school.#{scheme_flavor_name}"
        config.build_settings['PRODUCT_NAME'] = display_name
      end
    end
  end

  project.save
end

# Main execution starts here
if ARGV.length != 2
  puts "Usage: ruby update_project.rb <scheme_flavor_name> <display_name>"
  exit
end

scheme_flavor_name, display_name = ARGV

# Print the current directory
puts "Current directory: #{Dir.pwd}"

# Check if Info.plist exists
unless File.exist?(info_plist_path)
  puts "Info.plist not found at #{info_plist_path}"
  exit 1
end

# Backup Info.plist
FileUtils.cp(info_plist_path, "#{info_plist_path}.backup")

# Update Info.plist
update_info_plist(info_plist_path, scheme_flavor_name, display_name)

# Update Build Settings
update_build_settings(xcode_project_path, scheme_flavor_name, display_name)

puts "Project updated successfully."
