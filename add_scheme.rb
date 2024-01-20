def format_and_save_file
    file_path = './lib/config/flavor/flavor_config.dart'
  
    # Run dart format to format the file
    system("dart format #{file_path}")
  
    puts "\nflavor_config.dart file formatted successfully!"
  end

def get_user_input(prompt)
    print "#{prompt}: "
    gets.chomp
  end
  
  def validate_string_input(input, field_name)
    if input =~ /^[a-zA-Z0-9\s]+$/
      input.strip
    else
      puts "Error: #{field_name} should only contain letters, numbers, and spaces. Please enter again."
      nil
    end
  end
  
  def validate_integer_input(input, field_name)
    if input =~ /^\d+$/
      input.to_i
    else
      puts "Error: #{field_name} should be an integer. Please enter again."
      nil
    end
  end
  
  def generate_environment_type(app_name, company_name, company_code, url_name, scheme_name)
    <<~ENVIRONMENT_TYPE
      #{scheme_name}(
          urlName: '#{url_name}',
          companyCode: #{company_code},
          companyName: '#{company_name}',
          appName: '#{app_name}'),
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
        return [".mydynamicerp.com", ".dynamicerp.online", ".dynamicerp.com", ".dealersathi.com"][choice - 1]
      when 5
        # Prompt for custom URL input
        loop do
          print "Enter Custom URL (without Http): "
          custom_url = gets.chomp.strip
  
          if custom_url.empty?
            puts "Error: Custom URL is required and cannot be empty."
            next
          end
  
          # Trim "https://", "http://", and "www." if present
          custom_url = custom_url.gsub(/\Ahttps?:\/\//, "").gsub(/\Awww\./, "")
  
          return custom_url
        end
      else
        puts "Invalid selection. Please choose a valid extension or 'Custom'."
      end
    end
  end
  
  def main
    # Get user input
    app_name = validate_string_input(get_user_input("Enter appName"), "appName")
    company_name = validate_string_input(get_user_input("Enter companyName"), "companyName")
    company_code = validate_integer_input(get_user_input("Enter companyCode"), "companyCode")
    scheme_name = validate_string_input(get_user_input("Enter schemeName"), "schemeName")
  
    # Continue asking for input until all fields are valid
    while app_name.nil? || company_name.nil? || company_code.nil? || scheme_name.nil?
      app_name = validate_string_input(get_user_input("Enter appName"), "appName")
      company_name = validate_string_input(get_user_input("Enter companyName"), "companyName")
      company_code = validate_integer_input(get_user_input("Enter companyCode"), "companyCode")
      scheme_name = validate_string_input(get_user_input("Enter schemeName"), "schemeName")
    end
  
    # Select URL extension
    url_extension = select_url_extension
  
    # Save values into variables
    app_name_variable = app_name
    company_name_variable = company_name
    company_code_variable = company_code
    scheme_name_variable = scheme_name
  
    # Generate URL based on selected extension
    url_name_variable = "https://#{scheme_name}#{url_extension}"
  
    # Generate Environment Type code
    environment_type_code = generate_environment_type(app_name_variable, company_name_variable, company_code_variable, url_name_variable, scheme_name_variable)
  
    # Output the generated code
    puts "\nGenerated Environment Type Code:"
    puts "```dart"
    puts "enum EnvironmentType {"
    puts environment_type_code
    puts "}"
    puts "```"
  
    # Update the flavor_config.dart file
    update_flavor_config_file(environment_type_code)
    format_and_save_file
  
    puts "\nflavor_config.dart file updated successfully!"
  end
  
  # Run the script
  main
  