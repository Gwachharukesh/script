# update_files.rb

# Default values
default_bundle_identifier = "dynamic.school.mango"
default_scheme_name = "Mformang"

# Update the Fastfile
fastfile_path = File.expand_path('./ios/fastlane/Fastfile')
new_fastfile_content = <<-FASTFILE
# Define global variables
$app_identifier = "#{default_bundle_identifier}"
$scheme_name = "#{default_scheme_name}"
$app_name = "YourAppName" 

def generate_app_version_from_date
  current_date = Time.now.strftime("%Y.%m.%d")
  app_version = current_date
  return app_version
end

default_platform(:ios)

platform :ios do
  desc "Push a new release build to the App Store"

  lane :screenshots do
    capture_screenshots
    frame_screenshots(white: true)
  end

  lane :release do
    increment_build_number(xcodeproj: "Runner.xcodeproj")
    build_app(workspace: "Runner.xcworkspace", scheme: $scheme_name)

    upload_to_app_store(
      app_identifier: $app_identifier,
      platform: "ios",
      force: true,
      run_precheck_before_submit: false,
      precheck_include_in_app_purchases: false,
      api_key: app_store_connect_api_key(
        key_id: "465GZKBHDZ",
        issuer_id: "a2f3b0cc-ae36-4600-af4e-fb60f870bc9f",
        key_filepath: "fast_lane_deploy.p8",
        duration: 1200,
        in_house: false
      )
    )

    # submit_review 
  end

  lane :submit_review do
    deliver(
      app_version: app_version_with_date,
      app_identifier: $app_identifier,
      team_id: '5WGQ3638DG',
      skip_screenshots: false,
      username: "ios.dtechnp@gmail.com",  
      submit_for_review: true,
      automatic_release: true,
      force: true,
      overwrite_screenshots: false,
      languages: ['en-US'],
      metadata_path: "./metadata",
      skip_binary_upload: true,
      precheck_include_in_app_purchases: false,
      run_precheck_before_submit: true,
      submission_information: {
        add_id_info_limits_tracking: true,
        add_id_info_serves_ads: true,
        add_id_info_tracks_action: true,
        add_id_info_tracks_install: true,
        add_id_info_uses_idfa: true,
        content_rights_has_rights: true,
        content_rights_contains_third_party_content: true,
        export_compliance_platform: 'ios',
        export_compliance_compliance_required: false,
        export_compliance_encryption_updated: false,
        export_compliance_app_type: nil,
        export_compliance_uses_encryption: false,
        export_compliance_is_exempt: false,
        export_compliance_contains_third_party_cryptography: false,
        export_compliance_contains_proprietary_cryptography: false,
        export_compliance_available_on_french_store: true
      },
    )
  end
end
FASTFILE

File.write(fastfile_path, new_fastfile_content)

# Output the updated bundle identifier and scheme name for the Fastfile
puts "Updated bundle identifier in Fastfile: #{default_bundle_identifier}"
puts "Updated scheme name in Fastfile: #{default_scheme_name}"

# Update the Appfile
appfile_path = File.expand_path('./ios/fastlane/Appfile')
new_appfile_content = <<-APPFILE
$app_identifier = "#{default_bundle_identifier}"
app_identifier($app_identifier) # The bundle identifier of your app
apple_id("ios.dtechnp@gmail.com") # Your Apple Developer Portal username

itc_team_id("124017540") # App Store Connect Team ID
team_id("5WGQ3638DG") # Developer Portal Team ID
APPFILE

File.write(appfile_path, new_appfile_content)

# Output the updated bundle identifier for the Appfile
puts "Updated bundle identifier in Appfile: #{default_bundle_identifier}"
