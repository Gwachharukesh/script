# Function to validate the input
def validate_input(input)
  # Check if input is empty
  if input.empty?
    puts "Error: Input must not be empty."
    exit 1
  end

  # Check if input starts with a digit
  if input.match?(/\A\d/)
    puts "Error: Input cannot start with a digit."
    exit 1
  end

  # Check for special characters
  if input.match?(/[^\w\s]/)
    puts "Error: Input cannot contain special characters."
    exit 1
  end

  # Return the trimmed input
  input.strip
end

# Function to run a script and check its success
def run_script(script_name)
  puts "Running script: #{script_name}"
  success = system("ruby #{script_name}")
  unless success
    puts "Error running #{script_name}. Stopping execution."
    exit 1
  end
  puts "#{script_name} completed successfully."
end

# Prompt and validate the scheme name
print "Enter the scheme name: "
scheme_name = validate_input(STDIN.gets.chomp)

# Prompt and validate the app name
print "Enter the app name: "
app_name = validate_input(STDIN.gets.chomp)

# Prompt the user for the bundle identifier or set a default value
print "Enter the bundle identifier (or press Enter to use default): "
bundle_identifier = STDIN.gets.chomp
bundle_identifier = "dynamic.school.#{scheme_name}" if bundle_identifier.empty?

build_mode = "release"
app_icon_name = "Appicon-#{scheme_name}"
bundle_display_name = "#{app_name}-#{build_mode}"

scripts = [
  # "reset.rb",
  "launcher_icon.rb #{scheme_name}",
  "set_scheme.rb #{scheme_name}",
  "config_scheme.rb #{scheme_name}",
  "map_config.rb #{scheme_name}",
  "set_info.rb #{scheme_name} #{app_name}",
  "set_app_icon.rb #{scheme_name}"
]

# Run each script in sequence
scripts.each do |script|
  run_script(script)
end

puts "All scripts executed successfully."
