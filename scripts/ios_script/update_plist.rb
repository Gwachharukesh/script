# Path to your info.plist file
info_plist_path = './ios/Runner/info.plist'

# Provided content
new_info_plist_content = <<~XML
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
	<string>${FLUTTER_BUILD_NUMBER}</string>
	
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
XML

# Write the provided content to the info.plist file
File.write(info_plist_path, new_info_plist_content)

puts "Content replaced in #{info_plist_path}"
