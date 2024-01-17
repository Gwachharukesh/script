require 'xcodeproj'

project_path = './ios/Runner.xcodeproj'
target_name = 'Runner'

def update_provisioning_profile(project_path, target_name)
    project = Xcodeproj::Project.open(project_path)
    target = project.targets.find { |t| t.name == target_name }

    # Find the build settings for the Runner target
    build_settings = target.build_settings('Release')

    # Update provisioning profile to "Automatic"
    build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''

    # Save the changes to the Xcode project file
    project.save
end

# Call the method to update the provisioning profile
update_provisioning_profile(project_path, target_name)
