workspace 'RSDKUtils.xcworkspace'
project 'RSDKUtils.xcodeproj'

platform :ios, '12.0'

use_frameworks!

target 'Tests' do
  pod 'Quick', '~> 5.0'
  pod 'Nimble'
  pod 'SwiftLint', '~> 0.48.0' # Version 0.49+ requires macOS 12 and Swift 5.6
  pod 'RSDKUtils', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/TestHelpers', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/Nimble', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/RLogger', :path => './RSDKUtils.podspec'
end

# vim:syntax=ruby:et:sts=2:sw=2:ts=2:ff=unix:
