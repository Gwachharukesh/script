#!/usr/bin/env ruby

# Specify the path to your Flutter iOS project
project_path = './ios/Runner.xcodeproj'

# Specify the target name
target_name = 'Runner'

# Specify the team name
team_name = 'DYNAMIC TECHNOSOFT'

# Path to the automatically managed signing settings file
signing_settings_file = File.join(project_path, "project.pbxproj")

# Check if the signing settings are already up to date
already_up_to_date = File.read(signing_settings_file).include?("DevelopmentTeam = #{team_name};")

# If not up to date, update the automatically managed signing settings and set the team
unless already_up_to_date
  File.open(signing_settings_file, 'r+') do |file|
    file_data = file.read
    file_data.gsub!(/DevelopmentTeam = .+;/, "DevelopmentTeam = #{team_name};")
    file.seek(0)
    file.write(file_data)
    file.truncate(file.pos)
  end

  puts "Automatic signing enabled and Team set to #{team_name} for #{target_name} in #{project_path}"
else
  puts "Signing settings are already up to date. Skipping the update for #{target_name} in #{project_path}"
end
