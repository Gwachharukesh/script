#!/usr/bin/env ruby

# If the password is wrong, remove Fastlane user credentials
# `fastlane fastlane-credentials remove --username felix@krausefx.com`
# Run the script, and when prompted for the username, use ios.dtechnp@gmail.com
# After proper authentication, use the app-specific password mentioned below for automatic app uploads
# If there's a no signing certificate error, open iOS in Xcode, load the signing and capabilities tab, and then rerun the script

ENV['FASTLANE_USER'] = 'ios.dtechnp@gmail.com'
ENV['FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD'] = 'lyvw-rkui-lfla-oqdu'

# Specify flavors
flavors = [
  "gauSecSchPar",
  # Add other flavors as needed
]

# Specify app archive names corresponding to flavors
app_archive_names = [
  "Gautam Sec School",
  # Add other app archive names as needed
]

# Loop through flavors and perform necessary actions
flavors.each_with_index do |value, i|
  app_name = app_archive_names[i]
  puts "Building for flavor: #{value}, App Name: #{app_name}"

  # Run Flutter build for IPA with specified flavor and release mode
  system("flutter build ipa --flavor=#{value} --release")

  # Use Fastlane deliver to upload the app to App Store Connect
  system("fastlane deliver --force --ipa 'build/ios/ipa/#{app_name}.ipa' --skip-screenshots")

  # Add additional actions as needed, such as running tests or submitting for review
end

# Additional comments:
# - The script assumes that you have already set up Fastlane and configured it with necessary credentials.
# - Make sure to uncomment and customize any additional actions you may need.
# - Keep the script organized and commented for better readability.
