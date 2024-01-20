# run_fastlane_signing_cmd.rb

# Change the current working directory to the 'ios' folder
Dir.chdir('./ios')

system("fastlane create_bundle_identifier")
puts "Bundle Identifier for one Signal Created"
system("fastlane build_and_upload_app")
puts "Deployment script Build."
# Additional deployment logic can be added here
# For example, you can perform deployment tasks after running the Fastlane script

