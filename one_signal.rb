# Ruby script to automate adding a Notification Service Extension target in a Flutter iOS project

project_name = "Runner"
extension_target_name = "OneSignalNotificationServiceExtension"
organization_identifier = "ddynanmic.school.scheme_name"
bundle_identifier = "dynamic.school.scheme_name.OneSignalNotificationServiceExtension"
team_name = "DYNAMIC Technosoft"
project_path = './ios/Runner.xcodeproj'

# Step 1: Add a new target for Notification Service Extension
system("xcodebuild -project #{project_path} -list")
system("xcodebuild -project #{project_path} -target #{project_name} -list")
system("xcodebuild -project #{project_path} -target #{project_name} -verbose")
system("xcodebuild -project #{project_path} -target #{project_name} -configuration Debug -sdk iphonesimulator -derivedDataPath /tmp/MyApp")

# Step 2: Configure Notification Service Extension
extension_dir = "ios/#{extension_target_name}"
Dir.mkdir(extension_dir) unless File.directory?(extension_dir)

# Create NotificationService.swift
notification_service_code = <<-SWIFT
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
            OneSignal.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent, withContentHandler: self.contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            OneSignal.serviceExtensionTimeWillExpireRequest(self.receivedRequest, with: self.bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
    
}
SWIFT

File.write("#{extension_dir}/NotificationService.swift", notification_service_code)

# Step 3: Create Info.plist for Notification Service Extension
info_plist_path = "#{extension_dir}/Info.plist"
info_plist_content = <<-PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSExtension</key>
    <dict>
        <key>NSExtensionPointIdentifier</key>
        <string>com.apple.usernotifications.service</string>
        <key>NSExtensionPrincipalClass</key>
        <string>$(PRODUCT_MODULE_NAME).NotificationService</string>
    </dict>
</dict>
</plist>
PLIST

File.write(info_plist_path, info_plist_content)

# Step 4: Create OneSignalNotificationServiceExtension.entitlements
entitlements_path = "#{extension_dir}/OneSignalNotificationServiceExtension.entitlements"
entitlements_content = <<-ENTITLEMENTS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>aps-environment</key>
    <string>development</string>
</dict>
</plist>
ENTITLEMENTS

File.write(entitlements_path, entitlements_content)

# Step 5: Set up Xcode project settings
system("xcodebuild -project #{project_path} -target #{extension_target_name} -config Release -sdk iphoneos -derivedDataPath /tmp/#{extension_target_name}")

# Step 6: Set project settings
system("xcodebuild -project #{project_path} -target #{extension_target_name} -showBuildSettings")

puts "Automation script completed successfully."
