# Ruby script to update the content of ./ios/fastlane/.env file and use arguments directly

# Specify the path to the .env file
env_file_path = './ios/fastlane/.env'

# Define the new content to be added to the .env file
new_content = <<~EOF
FASTLANE_USER=ios.dtechnp@gmail.com
FASTLANE_TEAM_NAME=DYNAMIC TECHNOSOFT
FASTLANE_ITC_TEAM_NAME=DYNAMIC TECHNOSOFT

PRODUCE_APP_IDENTIFIER=%{bundle_id}
PRODUCE_APP_NAME=%{appname}
PRODUCE_VERSION=#{Time.now.strftime('%Y.%m.%d')}
PRODUCE_SKU=%{bundle_id}
PRODUCE_PLATFORMS=ios

MATCH_USERNAME=ios.dtechnp@gmail.com
MATCH_GIT_URL=git@github.com:Gwachharukesh/dynamiccertificates.git
MATCH_APP_IDENTIFIER=%{bundle_id}

MATCH_PLATFORM=ios

FL_PROJECT_SIGNING_PROJECT_PATH=Runner.xcodeproj
FL_PROJECT_SIGNING_TARGETS=Runner
FL_PROJECT_SIGNING_BUILD_CONFIGURATIONS=Release-%{scheme}
FL_PROJECT_USE_AUTOMATIC_SIGNING=true
FL_PROJECT_SIGN_IDENTITY=Apple Distribution

GYM_SCHEME=%{scheme}

GYM_OUTPUT_DIRECTORY=fastlanebuild/ios
IPHONEOS_DEPLOYMENT_TARGET=12
EOF

# Sample invocation with arguments
scheme, appname, bundle_id = ARGV

# Customize the content based on the provided arguments
new_content.gsub!("%{appname}", appname)
new_content.gsub!("%{bundle_id}", bundle_id)
new_content.gsub!("%{scheme}", scheme)

# Write the new content to the .env file, replacing its previous content
File.open(env_file_path, 'w') { |file| file.write(new_content) }

# Display a success message for .env file update
puts 'Content updated successfully in the .env file.'

# Display a message with the provided arguments
puts "Arguments received - Scheme: #{scheme}, Appname: #{appname}, Bundle ID: #{bundle_id}"

# Continue with the rest of your script logic...
