def display_menu
    puts "Choose an option:"
    puts "1. Add Flavor Only"
    puts "2. Add and Configure Flavor"
    puts "3. Add, Configure, and Publish"
    puts "4. Configure Scheme from List"
    puts "5. Fastlane"
    puts "6. Exit"
  end
  
  def add_flavor_only
    puts "Adding Flavor Only..."
    system("ruby ./scripts/ios_script/add_scheme.rb")
    # Add your logic for adding flavor here
  end
  
  def add_and_configure_flavor
    puts "Adding and Configuring Flavor..."
    system("ruby ./scripts/ios_script/add_and_configure_flavor.rb")
    # Add your logic for adding and configuring flavor here
  end
  
  def configure_scheme_from_list
    puts "Configuring Scheme from List..."
    # Add your logic for configuring scheme from the list here
  end
  
  def add_configure_and_publish
    puts "Adding, Configuring, and Publishing..."
    # Add your logic for adding, configuring, and publishing here
  end
  
  def fastlane
    puts "Running Fastlane..."
    # Add your logic for Fastlane here
  end
  
  loop do
    display_menu
  
    print "Enter your choice (1-6): "
    choice = gets.chomp.to_i
  
    case choice
    when 1
      add_flavor_only
    when 2
        display_menu
      add_and_configure_flavor
    when 3
      configure_scheme_from_list
    when 4
      add_configure_and_publish
    when 5
      fastlane
    when 6
      puts "Exiting..."
      break
    else
      puts "Invalid choice. Please enter a number between 1 and 6."
    end
  end
  