# update_files.rb

# Default values
DEFAULT_BUNDLE_IDENTIFIER = "dynamic.school.mango"
DEFAULT_SCHEME_NAME = "Mformang"
APP_NAME = ""

def update_fastfile(bundle_identifier, scheme_name)
  fastfile_path = File.expand_path('./ios/fastlane/Fastfile')
  new_fastfile_content = <<-FASTFILE
    # Define global variables
    $app_identifier = "#{bundle_identifier}"
    $scheme_name = "#{scheme_name}"
    $app_name = 'Orange'
    $app_version = "1.0.0"

    default_platform(:ios)

    platform :ios do
      desc "Push a new release build to the App Store"

      lane :screenshots do
        capture_screenshots
        frame_screenshots(white: true)
      end

      lane :release do
        increment_build_number(xcodeproj: "Runner.xcodeproj")
        build_app(
          workspace: "Runner.xcworkspace",
          scheme: $scheme_name,
          output_directory: "../build",
          output_name: "#{$scheme_name}.xcarchive"
        )

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
          app_identifier: $app_identifier,
          auto_release_date: true,
          team_id: '5WGQ3638DG',
          skip_screenshots: false,
          username: "ios.dtechnp@gmail.com",
          submit_for_review: true,
          automatic_release: true,
          force: true,
          overwrite_screenshots: false,
          languages: ['en-US'],
          metadata: {
            name: $app_name
          },
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
            content_rights_contains_third_party_content: false,
            export_compliance_platform: 'ios',
            export_compliance_compliance_required: false,
            export_compliance_encryption_updated: false,
            export_compliance_app_type: nil,
            export_compliance_uses_encryption: false,
            export_compliance_is_exempt: false,
            export_compliance_contains_third_party_cryptography: false,
            export_compliance_contains_proprietary_cryptography: false
          },
        )
      end
    end
  FASTFILE

  File.write(fastfile_path, new_fastfile_content)
  puts "Updated bundle identifier in Fastfile: #{bundle_identifier}"
  puts "Updated scheme name in Fastfile: #{scheme_name}"
end

def update_appfile(bundle_identifier)
  appfile_path = File.expand_path('./ios/fastlane/Appfile')
  new_appfile_content = <<-APPFILE
    $app_identifier = "#{bundle_identifier}"
    app_identifier($app_identifier) # The bundle identifier of your app
    apple_id("ios.dtechnp@gmail.com") # Your Apple Developer Portal username

    itc_team_id("124017540") # App Store Connect Team ID
    team_id("5WGQ3638DG") # Developer Portal Team ID
  APPFILE

  File.write(appfile_path, new_appfile_content)
  puts "Updated bundle identifier in Appfile: #{bundle_identifier}"
end

def update_deliverfile(bundle_identifier, app_name)
  deliverfile_path = File.expand_path('./ios/fastlane/Deliverfile')
  deliverfile_content = <<-DELIVERFILE
    # Deliverfile
    $app_identifier = "#{bundle_identifier}"
    # Define the app identifier
    app_identifier($app_identifier)
    
    # Define the username for App Store Connect
    username("ios.dtechnp@gmail.com")
    
    # Specify the build number (you can use variables or provide a static value)
    build_number("1")
    
    # Define metadata for different languages
    metadata_path("./fastlane/metadata")
    
    # Define screenshots path
    screenshots_path("./fastlane/screenshots")
    
    # Define app description and keywords for each language
    description({
      'en-US' => "#{app_name} School App is the comprehensive academic management solution designed for educational institutions, teachers, students, and parents. Streamline your daily activities and enhance your educational experience effortlessly! # ... (your existing description content)"
    })
    
    keywords({
      'en-US' => ['Academic Erp', 'Academic App', 'Nepal Academic App', app_name, "#{app_name} academic erp "],
    })
    
    # Define additional metadata
    promotional_text({
      'en-US' => 'All Academic Solution in One Place',
    })
    
    # Define support URL and marketing URL
    support_url({
      'en-US' => 'https://dynamic.net.np/contact-us',
    })
    
    marketing_url({
      'en-US' => 'https://dynamic.net.np/contact-us'
    })
    
    privacy_url({
      'en-US' => 'https://dynamic.net.np/privacy-policy'
    })
    
    # Define app review information
    app_review_information({
      contact_first_name: 'Rukesh',
      contact_last_name: 'Gwachha',
      contact_phone: '+9779860918184',
      contact_email: 'rukeshgwachha@gmail.com',
      demo_account_name: 'adminuat',
      demo_account_password: 'adminuat@2020',
      demo_account_instructions: 'Login and test the app'
    })
    
    # Define app pricing and availability
    # price_tier(0)
    # availability({
    #   'en-US' => 'Available on the App Store',
    # })
    
    # Define app rating information
    # rating_config_path('./fastlane/rating_config.json')
    
    # Define review notes for the app submission
    # review_notes({
    #   'en-US' => 'Release notes in English',
    #   'fr-FR' => 'Notes de version en français'
    # })
  DELIVERFILE

  File.write(deliverfile_path, deliverfile_content)
  puts "Updated bundle identifier in Deliverfile: #{bundle_identifier}"
  puts "Updated app name in Deliverfile: #{app_name}"
end

def main
  # Assign the provided default values to variables
  default_bundle_identifier = DEFAULT_BUNDLE_IDENTIFIER
  default_scheme_name = DEFAULT_SCHEME_NAME
  app_name = APP_NAME

  # Update the Fastfile
  update_fastfile(default_bundle_identifier, default_scheme_name)

  # Update the Appfile
  update_appfile(default_bundle_identifier)

  # Update the Deliverfile
  update_deliverfile(default_bundle_identifier, app_name)
end

# Main script
main
