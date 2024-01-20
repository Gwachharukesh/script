# update_bundle_identifier.rb

# Check if the new bundle identifier, scheme name, and name arguments are provided
if ARGV.length != 3
  puts "Usage: ruby update_bundle_identifier.rb [new_bundle_identifier] [new_scheme_name] [new_name]"
  exit 1
end

# Assign the provided arguments to variables
new_bundle_identifier, new_scheme_name, new_name = ARGV

# Update the Appfile
appfile_path = './ios/fastlane/Appfile'
appfile_content = File.read(appfile_path)
appfile_content.sub!(/\$app_identifier\s*=\s*".*"/, "$app_identifier = \"#{new_bundle_identifier}\"")
File.write(appfile_path, appfile_content)
puts "Updated bundle identifier in Appfile: #{new_bundle_identifier}"

# Update the Fastfile
fastfile_path = './ios/fastlane/Fastfile'
fastfile_content = File.read(fastfile_path)
fastfile_content.sub!(/\$app_identifier = .*/, "$app_identifier = \"#{new_bundle_identifier}\"")
fastfile_content.sub!(/\$scheme_name = .*/, "$scheme_name = \"#{new_scheme_name}\"")
File.write(fastfile_path, fastfile_content)
puts "Updated bundle identifier in Fastfile: #{new_bundle_identifier}"
puts "Updated scheme name in Fastfile: #{new_scheme_name}"

# Update metadata file
metadata_file_path = './ios/fastlane/metadata/en-US/name.txt'
existing_content = File.read(metadata_file_path)
puts "Current content in #{metadata_file_path}:"
puts existing_content
File.write(metadata_file_path, new_name)
puts "\nUpdated content in #{metadata_file_path}:"
puts new_name
