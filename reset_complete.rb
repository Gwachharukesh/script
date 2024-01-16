#!/usr/bin/env ruby

require 'fileutils'

# Function to delete the ios directory
def delete_ios_directory
  ios_path = File.join(Dir.pwd, 'ios')
  puts "Deleting existing ios directory..."
  FileUtils.rm_rf(ios_path) if Dir.exist?(ios_path)
end

# Function to recreate the ios directory using Flutter
def recreate_flutter_directory
  puts "Recreating ios directory..."
  system("flutter create .")
end

# Function to initialize and install CocoaPods in the ios directory
def init_and_install_cocoapods
  ios_path = File.join(Dir.pwd, 'ios')
  puts "Initializing and installing CocoaPods..."
  Dir.chdir(ios_path) do
    system('pod init')
    system('pod install')
  end
end

# Main execution
begin
  delete_ios_directory
  recreate_flutter_directory
  init_and_install_cocoapods

  puts "Reset Process completed successfully."
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
