require 'xcodeproj'

# Specify the path to your Xcode project
project_path = './ios/Runner.xcodeproj'

# Specify the target name (e.g., "Runner")
target_name = "Runner"

# Specify the build phase names to delete
build_phase_names = ["[CP] Check Pods Manifest.lock", "[CP] Embed Pods Frameworks"]

# Function to delete a build phase from a target
def delete_build_phase(project_path, target_name, build_phase_name)
  # Open the Xcode project
  project = Xcodeproj::Project.open(project_path)

  # Find the target by name
  target = project.targets.find { |t| t.name == target_name }

  if target
    # Find the build phase by display name
    build_phase = target.build_phases.find { |bp| bp.display_name == build_phase_name }

    if build_phase
      # Build phase found, delete it
      puts "Deleting build phase #{build_phase_name} from target #{target_name}"
      target.build_phases.delete(build_phase)
      project.save
    else
      # Build phase not found, skip deletion
      puts "Build phase #{build_phase_name} not found in target #{target_name}."
    end
  else
    # Target not found, cannot delete build phase
    puts "Target #{target_name} not found in the Xcode project."
  end
end

# Iterate through build phase names and delete them if found
build_phase_names.each do |build_phase_name|
  delete_build_phase(project_path, target_name, build_phase_name)
end
