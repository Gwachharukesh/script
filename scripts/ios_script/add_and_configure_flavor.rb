require 'colorize'
require 'uri'

# Define global variables
$app_name = ''
$company_name = ''
$company_code = 0
$scheme_name = ''
$url_extension = ''
$urlName = ''
$bundleId = '' # Make sure to assign an actual value to $bundleId


def get_user_input(prompt, variable)
  print "#{prompt}: "
  input = gets.chomp
  # Assign the input value to the specified global variable
  eval("#{variable} = '#{input}'")
end

def display_error_message(message)
  puts "Error: #{message}".red
end

def validate_string_input(input, field_name)
  if input =~ /^[a-zA-Z0-9\s]+$/
    input.strip
  else
    display_error_message("#{field_name} should only contain letters, numbers, and spaces. Please enter again.")
    validate_string_input(get_user_input("Enter #{field_name}", "$#{field_name.downcase}"), field_name)
  end
end

def validate_integer_input(input, field_name)
  if input =~ /^\d+$/
    input.to_i
  else
    display_error_message("#{field_name} should be an integer. Please enter again.")
    validate_integer_input(get_user_input("Enter #{field_name}", "$#{field_name.downcase}"), field_name)
  end
end

def validate_url_input(url)
  if url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
    url.strip
  else
    display_error_message("Invalid URL format. Please enter a valid URL.")
    validate_url_input(get_user_input("Enter URL", '$url_extension'))
  end
end

def environment_variable_exists?(content, variable_name)
  # Check if the content includes the specified environment variable name or code
  content.include?("#{variable_name}(")
end

def generate_environment_type(app_name, company_name, company_code, url_name, scheme_name, bundleId)
  <<~ENVIRONMENT_TYPE
    #{scheme_name}(
        urlName: '#{url_name}',
        companyCode: #{company_code},
        companyName: '#{company_name}',
        appName: '#{app_name}',
        bundleId: '#{bundleId}'),
  ENVIRONMENT_TYPE
end

def update_flavor_config_file(environment_type_code)
  file_path = './lib/config/flavor/flavor_config.dart'

  # Read the existing file content
  existing_content = File.read(file_path)

  # Append the new environment type code
  new_content = existing_content.gsub(/enum EnvironmentType \{/, "enum EnvironmentType {#{environment_type_code}")

  # Write the updated content back to the file
  File.write(file_path, new_content)
end

def select_url_extension
  loop do
    puts "Select URL Extension Type:"
    puts "1. .mydynamicerp.com"
    puts "2. .dynamicerp.online"
    puts "3. .dynamicerp.com"
    puts "4. .dealersathi.com"
    puts "5. Custom"

    print "Enter your choice (1-5): "
    choice = gets.chomp.to_i

    case choice
    when 1, 2, 3, 4
      $url_extension = [".mydynamicerp.com", ".dynamicerp.online", ".dynamicerp.com", ".dealersathi.com"][choice - 1]
      return $url_extension
    when 5
      # Prompt for custom URL input
      loop do
        print "Enter Custom URL (without Http): "
        custom_url = gets.chomp.strip

        if custom_url.empty?
          display_error_message("Custom URL is required and cannot be empty.")
          next
        end

        # Validate custom URL format
        validated_url = validate_url_input(custom_url)
        $url_extension = validated_url unless validated_url.nil?
        return $url_extension
      end
    else
      display_error_message("Invalid selection. Please choose a valid extension or 'Custom'.")
    end
  end
end

def select_bundleId
  loop do
    print "Enter Bundle Identifier (Press Enter to skip, default is dynamic.school.#{$scheme_name}): "
    bundleId = gets.chomp.strip

    if bundleId.empty?
      $bundleId = "dynamic.school.#{$scheme_name}"
      break
    elsif bundleId =~ /^\d+$/
      display_error_message("Bundle Identifier cannot be numeric only. Please enter a valid value.")
    elsif bundleId.length <= 15
      display_error_message("Bundle Identifier must be more than 20 characters. Please enter a valid value.")
    else
      $bundleId = bundleId
      break
    end
  end
end


def format_and_save_file
    file_path = './lib/config/flavor/flavor_config.dart'
  
    # Run dart format to format the file
    system("dart format #{file_path}")
  
    puts "\nflavor_config.dart file formatted successfully!"
  end

def terminate_script(message)
    display_error_message(message)
    exit 1
  end
  
  def add_and_configure_flavor
    # Get user input for scheme_name
    $scheme_name = validate_string_input(get_user_input("Enter schemeName", "$scheme_name"), "schemeName")
  
    # Read the existing file content
    file_path = './lib/config/flavor/flavor_config.dart'
    existing_content = File.read(file_path)
  
    # Check if the environment variable with the same name already exists
    if environment_variable_exists?(existing_content, $scheme_name)
      terminate_script("Environment variable with the name '#{$scheme_name}' already exists in flavor_config.dart. Aborting.")
    end
  
    # Check if the flavor name matches, app name is null, and company code matches
    if existing_content.include?("#{$scheme_name}(") && $app_name.nil? && environment_variable_exists?(existing_content, $company_code.to_s)
      terminate_script("Flavor with the name '#{$scheme_name}' already exists, and App Name is null with matching Company Code. Aborting.")
    end
  
    # Get user input for other variables
    $app_name = validate_string_input(get_user_input("Enter appName", "$app_name"), "appName")
    $company_name = validate_string_input(get_user_input("Enter companyName", "$company_name"), "companyName")
    $company_code = validate_integer_input(get_user_input("Enter companyCode", "$company_code"), "companyCode")
  
    # Continue asking for input until all fields are valid
    while $app_name.nil? || $company_name.nil? || $company_code.nil?
      $app_name = validate_string_input(get_user_input("Enter appName", "$app_name"), "appName")
      $company_name = validate_string_input(get_user_input("Enter companyName", "$company_name"), "companyName")
      $company_code = validate_integer_input(get_user_input("Enter companyCode", "$company_code"), "companyCode")
    end
  
    # Check if the environment variable with the same code already exists
    if environment_variable_exists?(existing_content, $company_code.to_s)
      terminate_script("Environment variable with the code '#{$company_code}' already exists in flavor_config.dart. Aborting.")
    end
  
    # Select URL extension
    select_url_extension
  
    # Select Bundle Identifier
    select_bundleId
  
    # Generate URL based on selected extension
    $urlName = "https://#{$scheme_name}#{$url_extension}"
  
    # Generate Environment Type code
    environment_type_code = generate_environment_type($app_name, $company_name, $company_code, $urlName, $scheme_name, $bundleId)
  
    # Output the generated code
    puts "\nGenerated Environment Type Code:"
    puts "```dart"
    puts "enum EnvironmentType {"
    puts environment_type_code
    puts "}"
    puts "```"
  
    # Confirm before updating the file
    print "\nDo you want to update flavor_config.dart file? (y/n): "
    confirmation = gets.chomp.downcase
  
    if confirmation == 'y'
      # Update the flavor_config.dart file
      update_flavor_config_file(environment_type_code)
  
      format_and_save_file
  
      # Display updated values
      $onesignal_bundle_identifier = $bundleId + ".OneSignalNotificationServiceExtension"
      puts "\n########## Updated Values ###########"
      puts "App Name: #{$app_name}"
      puts "Company Name: #{$company_name}"
      puts "Company Code: #{$company_code}"
      puts "Scheme Name: #{$scheme_name}"
      puts "URL Extension: #{$url_extension}"
      puts "Bundle Identifier: #{$bundleId}"
      puts "Bundle Identifier: #{$onesignal_bundle_identifier}"
      puts "######### Updated Values #############"
     
    
  
      # Continue with the remaining script logic
      system("ruby ./scripts/ios_script/launcher_icon.rb \"#{$scheme_name}\"")
      system("ruby ./scripts/ios_script/set_scheme.rb \"#{$scheme_name}\"")
      system("ruby ./scripts/ios_script/config_scheme.rb \"#{$scheme_name}\"")
      system("ruby ./scripts/ios_script/map_config.rb \"#{$scheme_name}\"")
      system("ruby ./scripts/ios_script/update_build_config.rb \"#{$scheme_name}\" \"#{$app_name}\" \"#{$bundleId}\"")
      system("ruby ./scripts/ios_script/set_app_icon.rb \"#{$scheme_name}\"")
      system("ruby ./scripts/ios_script/update_onesignal_id.rb \"#{$scheme_name}\" \"#{$onesignal_bundle_identifier}\"")
      system("ruby ./scripts/ios_script/pod_install.rb")
      system("ruby ./scripts/ios_script/delete_build_phase.rb")
  
      puts "\nflavor_config.dart file updated successfully!"
    else
      puts "\nCode generation canceled. No changes were made."
    end
  end

  def publishtoappstore(scheme_name, app_name, bundle_id )
    puts "\nConfirm the following details before proceeding:"
    puts "Scheme Name: #{scheme_name}"
    puts "Bundle Identifier: #{bundle_id}"
    puts "App Name: #{app_name}"
  
    print "\nDo you want to proceed with publishing to the App Store? (y/n): "
    confirmation = gets.chomp.downcase
  
    if confirmation == 'y'
      system("ruby ./scripts/ios_script/fastlane/update_fastlane_config.rb \"#{scheme_name}\" \"#{app_name}\" \"#{bundle_id}\"")
      puts "Updating Successful"
      puts "Publishing App to Appstore"
      system("ruby ./scripts/ios_script/fastlane/fastlane_publish.rb")
      puts "\nflavor_config.dart file updated successfully!"
    else
      puts "\nPublishing canceled. No changes were made."
    end
  end
  

  

  # Run the script
  add_and_configure_flavor
  # publishtoappstore($scheme_name, $app_name,$bundleId)
