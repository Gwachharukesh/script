# update_bundle_identifier.rb

# Check if the new bundle identifier, scheme name, and name arguments are provided
def validate_arguments
  unless ARGV.length == 3
    puts "Usage: ruby update_bundle_identifier.rb  [new_scheme_name] [new_name] [new_bundle_identifier]"
    exit 1
  end
end

def update_metadata(new_name)
  metadata_file_path = './ios/fastlane/metadata/en-US/name.txt'
  
  if File.exist?(metadata_file_path)
    update_metadata_file(metadata_file_path, new_name)
  else
    create_metadata_file(metadata_file_path, new_name)
  end
end

def create_metadata_file(file_path, initial_content)
  begin
    File.open(file_path, 'w') { |file| file.write("#{initial_content}\n") }
    puts "File created successfully with initial content: #{initial_content}"
  rescue StandardError => e
    puts "Error creating the file: #{e.message}"
    exit 1
  end
end

def update_metadata_file(file_path, new_name)
  begin
    File.write(file_path, new_name)
    puts "Updated content in #{file_path}:"
    puts new_name
  rescue StandardError => e
    puts "Error updating the file: #{e.message}"
    exit 1
  end
end

def update_env_file(new_bundle_identifier, new_scheme_name, new_name)
  env_file_path = './ios/fastlane/.env'
  if File.exist?(env_file_path)
    update_env_variables(new_bundle_identifier, new_scheme_name, new_name, env_file_path)
    display_updated_env(env_file_path)
  else
    puts "Error: .env file not found at #{env_file_path}"
    exit 1
  end
end

def update_env_variables(new_scheme_name, new_name, new_bundle_identifier,env_file_path = './ios/fastlane/.env')
  env_content = File.read(env_file_path)

  env_content.gsub!(/^FASTLANE_BUNDLE_IDENTIFIER=.*$/, "FASTLANE_BUNDLE_IDENTIFIER=\"#{new_bundle_identifier}\"")
  env_content.gsub!(/^FASTLANE_SCHEME_NAME=.*$/, "FASTLANE_SCHEME_NAME=\"#{new_scheme_name}\"")
  env_content.gsub!(/^FASTLANE_APP_NAME=.*$/, "FASTLANE_APP_NAME=\"#{new_name}\"")

  File.write(env_file_path, env_content)
end

def display_updated_env(env_file_path)
  puts "\nUpdated .env file with new values:"
  puts File.read(env_file_path)
end

# Main script
validate_arguments

# Assign the provided arguments to variables
 new_scheme_name, new_name,  new_bundle_identifier= ARGV

# update_metadata(new_name)
update_env_file(new_scheme_name, new_name ,new_bundle_identifier)
