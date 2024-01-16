require 'xcodeproj'
xcodeproj_path = "./ios/Runner.xcodeproj"

# Function to add OneSignal notification extension
def add_onesignal_extension(xcodeproj_path)
    puts "Adding OneSignal notification extension..."

    # Verify if the Xcode project file exists
    unless File.exist?(xcodeproj_path)
      puts "Error: Runner.xcodeproj not found. Make sure you are in the root of your Flutter project."
      return
    end

    # Open the Xcode project using the xcodeproj gem
    project = Xcodeproj::Project.open(xcodeproj_path)

    # Add OneSignal notification extension to the Xcode project
    extension_target = project.new_target(:app_extension, 'OneSignalNotificationServiceExtension', :ios, '10.0')
    extension_target.build_configurations.each do |config|
      config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'your.bundle.identifier.OneSignalNotificationServiceExtension'
    end

    project.save

    puts "OneSignal notification extension added successfully."
end

# Main script
begin
    # Set the path to the Flutter project
    flutter_project_path = Dir.pwd

    # Call the function to add OneSignal notification extension
    add_onesignal_extension(xcodeproj_path)
    
rescue => e
    # Error handling
    puts "Error: #{e.message}"
    exit 1
end
