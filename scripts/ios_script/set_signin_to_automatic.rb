require 'xcodeproj'

def enable_automatic_signing(project_path)
  project = Xcodeproj::Project.open(project_path)

  project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
      config.build_settings['DEVELOPMENT_TEAM'] = '5WGQ3638DG'
    end
  end

  project.save
end

# Replace 'path/to/YourProject.xcodeproj' with the actual path to your Flutter project's .xcodeproj file
project_path = './ios/Runner.xcodeproj'

enable_automatic_signing(project_path)