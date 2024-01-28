# Paths
notification_service_path = './ios/OneSignalNotificationServiceExtension/NotificationService.swift'
info_plist_path = './ios/OneSignalNotificationServiceExtension/Info.plist'
entitlements_path = './ios/OneSignalNotificationServiceExtension/OneSignalNotificationServiceExtension.entitlements'

# NotificationService.swift content
notification_service_content = <<-SWIFT
import UserNotifications
import OneSignalFramework

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var receivedRequest: UNNotificationRequest!
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // If your SDK version is < 3.5.0 uncomment and use this code:
            /*
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
            */

            /* DEBUGGING: Uncomment the 2 lines below to check this extension is executing
                          Note, this extension only runs when mutable-content is set
                          Setting an attachment or action buttons automatically adds this */
            //OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
            //bestAttemptContent.body = "[Modified] " + bestAttemptContent.body

            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent, withContentHandler: self.contentHandler)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }

}
SWIFT

# Info.plist content
info_plist_content = <<~PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>BGTaskSchedulerPermittedIdentifiers</key>
	<array>
		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	</array>
	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>$(PRODUCT_NAME)</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>${PRODUCT_NAME}</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>{your package name}</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>kpg</string>
			</array>
		</dict>
	</array>
	<key>CFBundleVersion</key>
	<string>20</string>
	
	<key>FlutterDeepLinkingEnabled</key>
	<true/>
	<key>ITSAppUsesNonExemptEncryption</key>
	<false/>
	<key>LSApplicationCategoryType</key>
	<string>public.app-category.education</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>LSSupportsOpeningDocumentsInPlace</key>
	<true/>
	<key>NSCameraUsageDescription</key>
	<string>This app requires access to your camera to allow you to capture images for your assignments and projects.</string>
	<key>NSFaceIDUsageDescription</key>
	<string>This app requires permission to your faceid inorder to login using biometrics</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>Location access is required to track the real-time location of students and school buses for safety and security purposes. Additionally, we use location data to ensure students are present and accounted for during exams. We will never share your location data with third parties</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>Location access is required to track the real-time location of students and school buses for safety and security purposes. Additionally, we use location data to ensure students are present and accounted for during exams. We will never share your location data with third parties</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>Location access is required to enable attendance tracking and allow students to view the real-time location of their school bus.We will never share your location data with third parties.</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>This app requires access to your microphone to allow you to attend online meeting and for presentation projects. </string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string> This app requires permission to your photo library inorder to Upload photos for assignments and projects.Also it allow students to save and share course materials such as lecture slides or notes. </string>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
	<key>UIBackgroundModes</key>
	<array>
		<string>processing</string>
		<string>remote-notification</string>
	</array>
	<key>UIFileSharingEnabled</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
	<key>io.flutter.embedded_views_preview</key>
	<true/>
	<key>LSApplicationQueriesSchemes</key>
<array>
   <string>whatsapp</string>
</array>
</dict>
</plist>

PLIST

# Entitlements.plist content
entitlements_content = <<~PLIST
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>aps-environment</key>
    <string>development</string>
  </dict>
  </plist>
PLIST

# Write the content to files
File.write(notification_service_path, notification_service_content)
File.write(info_plist_path, info_plist_content)

# Check if the entitlements file exists
if File.exist?(entitlements_path)
  # File exists, replace its content
  File.write(entitlements_path, entitlements_content)
  puts "Entitlements file updated successfully."
else
  # File doesn't exist, create it and paste the content
  File.write(entitlements_path, entitlements_content)
  puts "Entitlements file created successfully."
end

puts "Script execution completed."


# Podfile path
podfile_path = './ios/Podfile'

# New Podfile content
podfile_content = <<~PODFILE
  # Uncomment this line to define a global platform for your project
  platform :ios, '12.0'

  # CocoaPods analytics sends network stats synchronously affecting flutter build latency.
  ENV['COCOAPODS_DISABLE_STATS'] = 'true'

  project 'Runner', {
    'Debug' => :debug,
    'Profile' => :release,
    'Release' => :release,
  }

  def flutter_root
    generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
    unless File.exist?(generated_xcode_build_settings_path)
      raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
    end

    File.foreach(generated_xcode_build_settings_path) do |line|
      matches = line.match(/FLUTTER_ROOT\=(.*)/)
      return matches[1].strip if matches
    end
    raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
  end

  require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

  flutter_ios_podfile_setup

  target 'Runner' do
    use_frameworks!
    use_modular_headers!

    flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
    target 'RunnerTests' do
      inherit! :search_paths
    end
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)
    end
  end

  target 'OneSignalNotificationServiceExtension' do
    use_frameworks!
    pod 'OneSignalXCFramework', '>= 5.0.4'
  end
PODFILE

# Write the content to the Podfile
File.write(podfile_path, podfile_content)

puts "Podfile content updated successfully."
