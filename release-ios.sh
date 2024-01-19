flutter build ios --release --no-codesign

# Move into ios
cd ios



# Sync certificates
fastlane sync_match

# Build and upload to App Store / TestFlight
fastlane delivery