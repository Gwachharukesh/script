# Script to add OneSignal notification extension in Xcode for Flutter under target Runner

# Function to add OneSignal notification extension
def add_onesignal_extension(project_path)
    puts "Adding OneSignal notification extension..."
  
    # Path to the Xcode project file
    xcodeproj_path = File.join(project_path, 'Runner.xcodeproj')
  
    # Verify if the Xcode project file exists
    unless File.exist?(xcodeproj_path)
      puts "Error: Runner.xcodeproj not found. Make sure you are in the root of your Flutter project."
      return
    end
  
    # Add OneSignal notification extension to the Xcode project
    system("xcodeproj add-ext #{xcodeproj_path} -t Runner -e OneSignalNotificationServiceExtension")
  
    puts "OneSignal notification extension added successfully."
  end
  
  # Main script
  begin
    # Set the path to the Flutter project
    flutter_project_path = Dir.pwd
  
    # Call the function to add OneSignal notification extension
    add_onesignal_extension(flutter_project_path)
    
  rescue => e
    # Error handling
    puts "Error: #{e.message}"
    exit 1
  end
  