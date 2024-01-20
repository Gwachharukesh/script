require 'colorize'
require 'uri'

# Define global variables
$app_name = ''
$company_name = ''
$company_code = 0
$scheme_name_variable = ''
$url_extension = ''
$urlName = ''
$bundleId = ''

def format_and_save_file
  file_path = './lib/config/flavor/flavor_config.dart'

  # Run dart format to format the file
  system("dart format #{file_path}")

  puts "\nflavor_config.dart file formatted successfully!"
end

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
  print "Enter Bundle Identifier (Press Enter to skip, default is dynamic.school.#{$scheme_name_variable}): "
  bundleId = gets.chomp.strip

  if bundleId.empty?
    $bundleId = "dynamic.school.#{$scheme_name_variable}"
  else
    $bundleId = bundleId
  end
end

def add_scheme
  # Get user input for scheme_name
  $scheme_name_variable = validate_string_input(get_user_input("Enter schemeName", "$scheme_name_variable"), "schemeName")

  # Read the existing file content
  file_path = './lib/config/flavor/flavor_config.dart'
  existing_content = File.read(file_path)

  # Check if the environment variable with the same name already exists
  if environment_variable_exists?(existing_content, $scheme_name_variable)
    display_error_message("Environment variable with the name '#{$scheme_name_variable}' already exists in flavor_config.dart. Aborting.")
    return
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
    display_error_message("Environment variable with the code '#{$company_code}' already exists in flavor_config.dart. Aborting.")
    return
  end

  # Select URL extension
  select_url_extension

  # Select Bundle Identifier
  select_bundleId

  # Generate URL based on selected extension
  $urlName = "https://#{$scheme_name_variable}#{$url_extension}"

  # Generate Environment Type code
  environment_type_code = generate_environment_type($app_name, $company_name, $company_code, $urlName, $scheme_name_variable, $bundleId)

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
    puts "\n########## Updated Values ###########"
    puts "App Name: #{$app_name}"
    puts "Company Name: #{$company_name}"
    puts "Company Code: #{$company_code}"
    puts "Scheme Name: #{$scheme_name_variable}"
    puts "URL Extension: #{$url_extension}"
    puts "Bundle Identifier: #{$bundleId}"
    puts "######### Updated Values #############"

    puts "\nflavor_config.dart file updated successfully!"
  else
    puts "\nCode generation canceled. No changes were made."
  end
end

# Run the script
add_scheme
