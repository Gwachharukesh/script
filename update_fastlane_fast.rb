# Arguments provided by the user
scheme_name = ARGV[0]
app_name = ARGV[1]
bundleId = ARGV[2]

# Content of the modified Fastfile
fastfile_content = <<-RUBY
# Fastfile

# Set the default platform to iOS
default_platform(:ios)

platform :ios do

  # Define a lane to create a bundle identifier
  lane :create_bundle_identifier do
    # Create or update bundle identifier with a prefix
    bundle_identifier = "#{bundleId}.OneSignalNotificationServiceExtension"

    # Use sigh to create or update the bundle identifier in Apple Developer
    sigh(
      app_identifier: bundle_identifier,
      skip_certificate_verification: true # Skip certificate verification if needed
    )
  end

  # Define a lane to build and upload the app
  lane :build_and_upload_app do
    # Example: Build the app using Flutter
    sh "flutter build ios"

    # Additional build steps if needed

    # Example: Build the Xcode project
    sh "xcodebuild -project Runner.xcodeproj -scheme #{scheme_name}"

    # Additional build commands

    # Example: Sign and package the app
    sh "fastlane match appstore"

    # Capture screenshots with frameit
    frameit(
      white_frame: true, # Customize as needed
      locale: "en-US",   # Set the locale for the screenshots
      devices: ["iPhone13ProMax", "iPhone12ProMax", "iPhone8Plus"] # Devices with different display sizes
    )

    # Upload to App Store with metadata
    upload_to_app_store(
      skip_screenshots: false, # Set this to false to include screenshots
      api_key: app_store_connect_api_key(
        key_id: "465GZKBHDZ",
        issuer_id: "a2f3b0cc-ae36-4600-af4e-fb60f870bc9f",
        key_filepath: "../../fast_lane_deploy.p8",
        duration: 1200, # Optional (maximum 1200)
        in_house: false # Optional but may be required if using match/sigh
      )
    )

    # Upload additional metadata using deliver
    deliver(
      app_identifier: bundleId,
      force: true, # Set to true to force an update
      skip_screenshots: false, # Set to false to include screenshots
      app_version: "1.0", # Specify the app version

      # Metadata
      app_name: app_name,
      promotional_text: "App to centralize academic task",
      description: " #{app_name} School App is the comprehensive academic management solution designed for educational institutions, teachers, students, and parents. Streamline your daily activities and enhance your educational experience effortlessly!

      Features:

      For Teachers:

      Effortlessly manage attendance records with a tap.
      Simplify homework assignments, grading, and parent communication.
      Quickly input grades and comments for report cards.
      For Students:

      Submit homework assignments with ease.
      Stay updated on attendance and academic progress.
      Access report cards and track your educational journey.
      For Parents:

      Receive real-time attendance alerts for your child.
      Monitor homework assignments and grades effortlessly.
      Conveniently pay school fees and access fee summaries.
      For Non-Teaching Staff:

      Manage attendance and leave requests efficiently.
      Stay connected with colleagues and administrators.
      Streamline daily operations effortlessly.
      For the Public:

      Explore the institution without the need to log in. Discover:
      Upcoming events and past activities.
      Vision, mission, and admission procedures.
      Notices, academic programs, suggestions, facilities, and galleries.
      Holiday schedules for planning your visits.
      Key Benefits:

      Seamless communication: Stay connected with your educational community.
      Efficient task management: Simplify daily activities, from attendance to homework.
      Accessible information: Public access promotes transparency and engagement.
      Empower your education: Monitor progress and analyze student activities.
      User-friendly and secure: Your data is protected, and navigation is intuitive.
      Empower your educational journey with the Bal Sansar School App. Whether you're a teacher, student, parent, or part of the community, this app puts the institution at your fingertips. Download now and experience the future of academic management!",
      keywords: "dynamic Technosoft, academic Erp, school management software",
      copyright: "2024 Dynamic Technosoft Pvt. Ltd.",# Privacy Policy URL
      privacy_url: "https://www.dynamictechnosoft.com/privacypolicy",
      support_url: "https://www.dynamic.net.np/contact-us", # Your support URL
      marketing_url: "https://www.dynamic.net.np/contact-us", #

      # App Privacy Settings
      data_collection: false, # Set to false if your app does not collect data

      # Sign-in required settings
      username: "anish15",
      password: "113407",

      # Contact Information
      first_name: "Rukesh",
      last_name: "Gwachha",
      phone_number: "9860918194",
      email: "rukeshgwachha@gmail.com",
      notes: "login detail",
      whats_new: " ui updates\n- kyc module updates\n- admin finance updates\n- bug fixes",

      # Version Release Settings
      automatic_release: true,

      # Pricing and Availability
      price_tier: "0", # Free
      availability_regions: "NP, IN", # All Nepal and India

      # App Information Settings
      age_rating: "none", # Set age rating to none
      unrestricted_web_access: false, # Set to false for no unrestricted web access
      gambling_and_contests: false # Set to false for no instance of gambling options
    )

    # Additional deployment steps

    # Additional post-build tasks
  end

  # Add more lanes or customize as needed

end
RUBY

# File path
file_path = './ios/fastlane/Fastfile'

# Erase the content and write the modified code to the Fastfile
File.write(file_path, fastfile_content)

puts "Fastfile has been updated successfully."
