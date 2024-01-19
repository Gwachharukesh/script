# run_fastlane_signing_cmd.rb

# Change the current working directory to the 'ios' folder
Dir.chdir('./ios')

system("fastlane ios create_bundle_identifier")
# system("fastlane ios build")
# puts "Deployment script Build."

system("build_and_upload_app")
puts "Deployment script Build."
# Additional deployment logic can be added here
# For example, you can perform deployment tasks after running the Fastlane script

