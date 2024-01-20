# update_bundle_identifier.rb

# Check if the new bundle identifier, scheme name, and name arguments are provided
def validate_arguments
  unless ARGV.length == 3
    puts "Usage: ruby update_bundle_identifier.rb [new_bundle_identifier] [new_scheme_name] [new_name]"
    exit 1
  end
end

def update_appfile(new_bundle_identifier)
  appfile_path = './ios/fastlane/Appfile'
  appfile_content = File.read(appfile_path)
  appfile_content.sub!(/\$app_identifier\s*=\s*".*"/, "$app_identifier = \"#{new_bundle_identifier}\"")
  File.write(appfile_path, appfile_content)
  puts "Updated bundle identifier in Appfile: #{new_bundle_identifier}"
end

def update_fastfile(new_scheme_name,new_bundle_identifier) 
  fastfile_path = './ios/fastlane/Fastfile'
  fastfile_content = File.read(fastfile_path)
  fastfile_content.sub!(/\$app_identifier = .*/, "$app_identifier = \"#{new_bundle_identifier}\"")
  fastfile_content.sub!(/\$scheme_name = .*/, "$scheme_name = \"#{new_scheme_name}\"")
  File.write(fastfile_path, fastfile_content)
  puts "Updated bundle identifier in Fastfile: #{new_bundle_identifier}"
  puts "Updated scheme name in Fastfile: #{new_scheme_name}"
end

def update_metadata(new_name)
  metadata_file_path = './ios/fastlane/metadata/en-US/name.txt'
  if File.exist?(metadata_file_path)
    puts "File already exists at #{metadata_file_path}"
  else
    create_metadata_file(metadata_file_path)
  end

  existing_content = File.read(metadata_file_path)
  puts "Current content in #{metadata_file_path}:"
  puts existing_content

  File.write(metadata_file_path, new_name)
  puts "\nUpdated content in #{metadata_file_path}:"
  puts new_name
end

def create_metadata_file(file_path)
  begin
    File.open(file_path, 'w') { |file| file.write("Default Name\n") }
    puts "File created successfully with initial content: Default Name"
  rescue StandardError => e
    puts "Error creating the file: #{e.message}"
  end
end

# Main script
validate_arguments

# Assign the provided arguments to variables
new_scheme_name,new_bundle_identifier , new_name = ARGV

update_appfile(new_bundle_identifier)
update_fastfile(new_scheme_name,new_bundle_identifier )
update_metadata(new_name)
