require 'xcodeproj'
# Specify the path to your Xcode project
project_path = './ios/Runner.xcodeproj'

# Specify the target name (e.g., "Runner")
target_name = "Runner"

# Specify the build phase names to delete
build_phase_names = ["[CP] Check Pods Manifest.lock", "[CP] Embed Pods Frameworks"]

def delete_build_phase(project_path, target_name, build_phase_name)
  project = Xcodeproj::Project.open(project_path)

  target = project.targets.find { |t| t.name == target_name }

  if target
    build_phase = target.build_phases.find { |bp| bp.display_name == build_phase_name }

    if build_phase
      puts "Deleting build phase #{build_phase_name} from target #{target_name}"
      target.build_phases.delete(build_phase)
      project.save
    else
      puts "Build phase #{build_phase_name} not found in target #{target_name}."
    end
  else
    puts "Target #{target_name} not found in the Xcode project."
  end
end




# Delete specified build phases
build_phase_names.each do |build_phase_name|
  delete_build_phase(project_path, target_name, build_phase_name)
end
