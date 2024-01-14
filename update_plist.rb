require 'plist'
require 'fileutils'

# Constants for paths
PLIST_PATH = "./ios/Runner/Info.plist" # Set the path to your Info.plist

def update_info_plist(scheme_name, app_name, bundle_identifier)
  puts "Updating Info.plist for scheme: #{scheme_name}..."
  
  begin
    plist = Plist.parse_xml(PLIST_PATH)

    plist['CFBundleName'] = app_name
    plist['CFBundleIdentifier'] = bundle_identifier
    plist['CFBundleDisplayName'] = app_name

    build_number = plist['CFBundleVersion'].to_i
    plist['CFBundleVersion'] = build_number + 1

    Plist::Emit.save_plist(plist, PLIST_PATH)

    sleep 1 # Wait for the filesystem to sync

    updated_plist = Plist.parse_xml(PLIST_PATH)
    if updated_plist['CFBundleName'] == app_name &&
       updated_plist['CFBundleIdentifier'] == bundle_identifier &&
       updated_plist['CFBundleDisplayName'] == app_name
      puts "Info.plist updated successfully for scheme: #{scheme_name}."
    else
      puts "Failed to update Info.plist for scheme: #{scheme_name}. Values in the file do not match the expected ones."
    end
  rescue StandardError => e
    puts "An error occurred while updating Info.plist: #{e.message}"
  end
end
