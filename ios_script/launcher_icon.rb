require 'fileutils'

# Get scheme name from command line arguments
scheme_name = ARGV[0]

# Check if scheme_name is provided
unless scheme_name
  puts "Usage: ruby launcher_icon.rb <scheme_name>"
  exit 1
end

# Check if AppIcon-scheme_name.appiconset already exists
ios_asset_file = "./ios/Runner/Assets.xcassets/AppIcon-#{scheme_name}.appiconset"
# Define the flavor icons folder path
flavor_icons_folder = "./flavor_icons"

if Dir.exist?(ios_asset_file)
  puts "AppIcon-#{scheme_name}.appiconset already exists in ./ios/Runner/Assets.xcassets"
  exit 1
end



# Check if the flavor icons folder exists
unless Dir.exist?(flavor_icons_folder)
  puts "Flavor icons folder not found at #{flavor_icons_folder}"
  exit 1
end

# Search for an image file matching the scheme_name
image_extensions = %w[jpeg jpg png] # Add other image formats if needed
matching_image = nil

image_extensions.each do |extension|
  image_filename = "#{scheme_name}.#{extension}"
  image_path = File.join(flavor_icons_folder, image_filename)

  if File.exist?(image_path)
    matching_image = image_filename
    break
  end
end

# If matching image found, create the YAML file
if matching_image
  yaml_content = <<~YAML
    flutter_launcher_icons:
      android: true
      ios: true
      remove_alpha_ios: true # Ensures transparency is removed for iOS icons
      image_path: "./flavor_icons/#{matching_image}"
  YAML

  yaml_file_path = "flutter_launcher_icons-#{scheme_name}.yaml"
  File.write(yaml_file_path, yaml_content)

  puts "Created #{yaml_file_path} with the following content:\n\n#{yaml_content}"

  # Run flutter command
  if system("dart run flutter_launcher_icons:main")
    puts "Successfully executed dart run flutter_launcher_icons:main"
    # Delete the YAML file after the successful execution of the flutter command
    File.delete(yaml_file_path)
    puts "Deleted #{yaml_file_path}"
  else
    puts "Failed to execute dart run flutter_launcher_icons:main"
  end
else
  puts "No matching image found for scheme_name #{scheme_name}"
end