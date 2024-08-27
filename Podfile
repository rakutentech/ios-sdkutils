workspace 'RSDKUtils.xcworkspace'
project 'RSDKUtils.xcodeproj'

platform :ios, '14.0'

use_frameworks!

target 'Sample' do
  pod 'RSDKUtils', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/REventLogger', :path => './RSDKUtils.podspec'
end

target 'Tests' do
  pod 'Quick', '~> 5.0'
  pod 'Nimble'
  pod 'SwiftLint', '~> 0.50'
  pod 'RSDKUtils', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/TestHelpers', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/Nimble', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/RLogger', :path => './RSDKUtils.podspec'
  pod 'RSDKUtils/REventLogger', :path => './RSDKUtils.podspec'
end

# vim:syntax=ruby:et:sts=2:sw=2:ts=2:ff=unix:
