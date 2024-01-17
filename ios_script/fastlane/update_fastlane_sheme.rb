# Extract the scheme name from the command line argument
scheme_name = ARGV[0]

# Check if the scheme name is provided
if scheme_name.nil?
  puts "Error: Please provide the scheme name. Example: ruby fastlane_config.rb YourAppScheme"
  exit 1
end

# Fastlane script content
fastlane_script_content = <<~FASTLANE_SCRIPT
lane :createapp do
    create_app_online
  end
  
  
  
  platform :ios do
    
    lane :signing do
      sync_code_signing
      mapping = Actions.lane_context[
        SharedValues::MATCH_PROVISIONING_PROFILE_MAPPING
      ]
      update_code_signing_settings(
        profile_name: mapping[ENV["MATCH_APP_IDENTIFIER"]]
      )
    end
  
    lane :build do
      signing
    
    end
    lane :release do
      gym(scheme: "#{scheme_name}", export_method: "ad-hoc")
    end
  end
FASTLANE_SCRIPT

# Path to the Fastlane script
fastlane_script_path = "./ios/fastlane/Fastfile"
File.write(fastlane_script_path, fastlane_script_content)

puts "Fastlane script updated successfully with scheme: #{scheme_name}"
