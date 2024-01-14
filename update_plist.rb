require 'plist'
require 'fileutils'

# Constants for paths
PLIST_PATH = "./ios/Runner/Info.plist" # Set the path to your Info.plist

def update_info_plist(scheme_name, build_configuration)
  puts "Updating Info.plist for scheme: #{scheme_name}..."

  begin
    plist = Plist.parse_xml(PLIST_PATH)

    product_name = `xcodebuild -target #{scheme_name} -configuration #{build_configuration} -showBuildSettings | grep PRODUCT_NAME | awk -F= '{print $2}'`.strip
    bundle_identifier = `xcodebuild -target #{scheme_name} -configuration #{build_configuration} -showBuildSettings | grep PRODUCT_BUNDLE_IDENTIFIER | awk -F= '{print $2}'`.strip

    # Extracting 'schemename' from 'Release-schemename'
    schemename = scheme_name.gsub(/^Release-/, '').gsub(/-schemename$/, '')

    puts "Before Update:"
    puts "CFBundleName: #{plist['CFBundleName']}"
    puts "CFBundleIdentifier: #{plist['CFBundleIdentifier']}"
    puts "CFBundleDisplayName: #{plist['CFBundleDisplayName']}"

    plist['CFBundleName'] = product_name
    plist['CFBundleIdentifier'] = bundle_identifier
    plist['CFBundleDisplayName'] = product_name

    build_number = plist['CFBundleVersion'].to_i
    plist['CFBundleVersion'] = build_number + 1

    Plist::Emit.save_plist(plist, PLIST_PATH)

    sleep 1 # Wait for the filesystem to sync

    updated_plist = Plist.parse_xml(PLIST_PATH)

    puts "After Update:"
    puts "CFBundleName: #{updated_plist['CFBundleName']}"
    puts "CFBundleIdentifier: #{updated_plist['CFBundleIdentifier']}"
    puts "CFBundleDisplayName: #{updated_plist['CFBundleDisplayName']}"

    if updated_plist['CFBundleName'] == product_name &&
       updated_plist['CFBundleIdentifier'] == bundle_identifier &&
       updated_plist['CFBundleDisplayName'] == product_name
      puts "Info.plist updated successfully for scheme: #{scheme_name}."
    else
      puts "Failed to update Info.plist for scheme: #{scheme_name}. Values in the file do not match the expected ones."
    end
  rescue StandardError => e
    puts "An error occurred while updating Info.plist: #{e.message}"
  end
end

# Example usage:
# update_info_plist('Release-schemename', 'Release')
