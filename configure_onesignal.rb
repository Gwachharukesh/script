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
