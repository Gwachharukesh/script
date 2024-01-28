def display_menu
  puts "Choose an option:"
  puts "1. Add Flavor Only"
  puts "2. Add and Configure Flavor"
  puts "3. Add, Configure, and Publish"
  puts "4. Configure Scheme from List"
  puts "5. Publish From the List"
  puts "6. Fastlane Initialize"
  puts "7. Xcode SignIn to Automatic"
  puts "8. Xcode Delete Build Phase"
  puts "9. Initialize Xcode setup"
  puts "10. create scheme from List"
  puts "0. Exit"
end

def add_flavor_only
  puts "Adding Flavor Only..."
  system("ruby ./scripts/ios_script/add_scheme.rb")
  # Add your logic for adding flavor here
end

def add_and_configure_flavor
  puts "Adding and Configuring Flavor..."
  system("ruby ./scripts/add_config_publish.rb")
  # Add your logic for adding and configuring flavor here
end

def configure_scheme_from_list
  puts "Configuring Scheme from List..."
  # Add your logic for configuring the scheme from the list here
end

def add_configure_publish
  puts "Adding, Configuring, and Publishing..."
  system("ruby ./scripts/ios_script/add_config_publish.rb")
  # Add your logic for adding, configuring, and publishing here
end

def fastlane_init
  puts "Running Fastlane..."
  system("ruby ./scripts/ios_script/fastlane/init_fastlane.rb")
  # Add your logic for Fastlane here
end

def publishfromlist
  puts "Running Fastlane..."
  system("ruby ./scripts/ios_script/publish_from_list.rb")
  # Add your logic for Fastlane here
end

def only_configure_scheme_from_list
  puts "Running Fastlane..."
  system("ruby ./scripts/ios_script/config_scheme_only_from_list.rb")
  # Add your logic for Fastlane here
end
def reconfig_scheme_and_map
  puts "Running Fastlane..."
  system("ruby ./scripts/ios_script/reconfig_scheme_and_map.rb")
  # Add your logic for Fastlane here
end
def set_signin_automatic
  puts "setting signin config to automatic "
  system("ruby ./scripts/ios_script/set_signin_to_automatic.rb")
  puts "setting signin config to automatic done "
end

loop do
  display_menu

  print "Enter your choice (0-9): "
  choice = gets.chomp.to_i

  case choice
  when 1
    add_flavor_only
  when 2
    add_and_configure_flavor
  when 3
    add_configure_publish
  when 4
    puts "Add Option functions."
    only_configure_scheme_from_list
  when 5
    publishfromlist
  when 6
    puts "Initializing Fast Lane Files..."
    fastlane_init
  when 7
    set_signin_automatic
  when 8, 9
    puts "Add Option functions."
  when 10
    reconfig_scheme_and_map
  when 0
    puts "Exiting the script."
    break
  else
    puts "Invalid choice. Please enter a number between 0 and 9."
  end
end
