# Script to delete pod.lock and reinstall pods for Flutter iOS

# Path to the ios folder
ios_path = "./ios"

# Full path to pod.lock file
pod_lock_path = "./ios/Podfile.lock"

# Check if pod.lock file exists
if File.exist?(pod_lock_path)
  puts "Deleting existing pod.lock file..."
  File.delete(pod_lock_path)
  puts "Deleted pod.lock file."
else
  puts "No existing pod.lock file found."
end

# Run pod install
puts "Running pod install..."
system("cd #{ios_path} && pod install")
puts "Pod installation completed."
