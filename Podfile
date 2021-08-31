workspace 'RSDKUtils.xcworkspace'
project 'RSDKUtils.xcodeproj'

platform :ios, '10.0'

use_frameworks!

target 'Tests' do
  pod 'Quick'
  pod 'Nimble'
  pod 'RSDKUtils', :path => './RSDKUtils.podspec'
end

post_install do |installer|
  # Needed so 'internal' module classes can be tested
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['ENABLE_TESTABILITY'] = 'YES'
    end
  end
end

# vim:syntax=ruby:et:sts=2:sw=2:ts=2:ff=unix:
