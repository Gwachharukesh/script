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

# Prompt the user for the scheme name
print "Enter the scheme name: "
scheme_name = STDIN.gets.chomp

# Ensure scheme_name is not empty
if scheme_name.empty?
  puts "Error: Scheme name must not be empty."
  exit 1
end

# Prompt the user for the app name
print "Enter the app name: "
app_name = STDIN.gets.chomp

# Ensure app_name is not empty
if app_name.empty?
  puts "Error: App name must not be empty."
  exit 1
end

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

