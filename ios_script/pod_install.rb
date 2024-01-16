ios_path = "./ios"

# Full paths to Pods directory and Podfile.lock
pods_path = File.join(ios_path, "Pods")
pod_lock_path = File.join(ios_path, "Podfile.lock")

# Delete Pods directory
puts "Deleting Pods directory..."
system("rm -rf #{pods_path}")
puts "Deleted Pods directory."

# Delete Podfile.lock
puts "Deleting Podfile.lock..."
File.delete(pod_lock_path) if File.exist?(pod_lock_path)
puts "Deleted Podfile.lock."

puts "Xcode Flutter iOS project reset without using flutter clean."

# Run pod install
puts "Running pod install..."
system("cd #{ios_path} && pod install")
puts "Pod installation completed."