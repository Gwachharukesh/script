# Check if scheme name is provided as an argument
scheme_name = ARGV[0]

# Validate that scheme name is provided
unless scheme_name
  puts "Error: Please provide the scheme name as an argument."
  exit 1
end

# Navigate to the 'ios' directory
ios_directory = File.expand_path('./ios')
Dir.chdir(ios_directory)

# Install CocoaPods dependencies
system('pod install')

# Define the paths for the file lists
input_file_list_path = "/Target Support Files/Pods-Runner/Pods-Runner-frameworks-#{scheme_name}-input-files.xcfilelist"
output_file_list_path = "/Target Support Files/Pods-Runner/Pods-Runner-frameworks-#{scheme_name}-output-files.xcfilelist"

# Ensure the existence of input file list, create it if not
unless File.exist?(input_file_list_path)
  File.write(input_file_list_path, '')
  puts "Created #{input_file_list_path}"
end

# Ensure the existence of output file list, create it if not
unless File.exist?(output_file_list_path)
  File.write(output_file_list_path, '')
  puts "Created #{output_file_list_path}"
end

# Display success message
puts "CocoaPods installation and file lists creation completed successfully for scheme '#{scheme_name}'."
