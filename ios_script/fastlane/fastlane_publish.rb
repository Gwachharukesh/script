# run_fastlane_signing_cmd.rb

# Change the current working directory to the 'ios' folder
Dir.chdir('./ios')

# Run the Fastlane signing lane command
system("fastlane createapp")
puts "Deployment script createApp."

system("fastlane ios signing")
puts "Deployment script Signing."

# system("fastlane ios build")
# puts "Deployment script Build."

system("fastlane ios release")
puts "Deployment script Build."
# Additional deployment logic can be added here
# For example, you can perform deployment tasks after running the Fastlane script

