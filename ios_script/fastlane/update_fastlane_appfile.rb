# Argument provided by the user
bundleId = ARGV[0]

# Content for the Appfile
appfile_content = <<~RUBY
# Appfile

app_identifier("#{bundleId}") # The bundle identifier of your app
apple_id("DYNAMIC TECHNOSOFT")
RUBY

# File path
appfile_path = './ios/fastlane/Appfile'

# Erase the content and write the modified code to the Appfile
File.write(appfile_path, appfile_content)

puts "Appfile has been updated successfully."
