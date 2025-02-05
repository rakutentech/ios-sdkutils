Pod::Spec.new do |s|
  s.name         = "RSDKUtils"
  s.version      = "5.1.0"
  s.authors      = "Rakuten Ecosystem Mobile"
  s.summary      = "Rakuten's SDK Team internal utilities module."
  s.homepage     = "https://github.com/rakutentech/ios-sdkutils"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/rakutentech/ios-sdkutils.git", :tag => s.version.to_s }
  s.platforms    = { :ios => '14.0' }
  s.swift_versions = ['5.4', '5.5', '5.9']
  s.resources = ['Sources/Resources/PrivacyInfo.xcprivacy']
  s.requires_arc = true
  s.pod_target_xcconfig = {
    'CLANG_ENABLE_MODULES'                                  => 'YES',
    'CLANG_MODULES_AUTOLINK'                                => 'YES',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
    'GCC_C_LANGUAGE_STANDARD'                               => 'gnu11',
    'OTHER_CFLAGS'                                          => "'-DRPT_SDK_VERSION=#{s.version.to_s}'"
  }
  s.user_target_xcconfig = {
    'CLANG_ENABLE_MODULES'                                  => 'YES',
    'CLANG_MODULES_AUTOLINK'                                => 'YES',
    'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
  }
  s.weak_frameworks = [
    'Foundation'
  ]
  s.module_map = './RSDKUtils.modulemap'
  s.default_subspec = 'Main'
  s.source_files = 'Sources/*.h'
  s.public_header_files = 'Sources/*.h'

  s.subspec 'Main' do |ss|
    ss.source_files = 'Sources/RSDKUtilsMain/**/*.swift', 'Sources/*.h'
    ss.dependency 'RSDKUtils/RLogger'
  end

  s.subspec 'TestHelpers' do |ss|
    ss.source_files = 'Sources/RSDKUtilsTestHelpers/**/*.swift'
    ss.weak_frameworks = [
      'XCTest'
    ]
    ss.pod_target_xcconfig = {
      'ENABLE_TESTING_SEARCH_PATHS' => 'YES',
      'OTHER_LDFLAGS'               => '$(inherited) -weak-lXCTestSwiftSupport'
    }
    ss.dependency 'RSDKUtils/Main'
  end

  s.subspec 'Nimble' do |ss|
    ss.ios.source_files = 'Sources/RSDKUtilsNimble/**/*.swift'
    ss.ios.dependency 'Nimble'
    ss.dependency 'RSDKUtils/Main'
  end

  s.subspec 'RLogger' do |ss|
    ss.source_files = 'Sources/RLogger/**/*.swift', 'Sources/*.h'
  end

  s.subspec 'REventLogger' do |ss|
    ss.source_files = 'Sources/REventLogger/**/*.swift', 'Sources/*.h'
    ss.dependency 'RSDKUtils/Main'
  end
end
# vim:syntax=ruby:et:sts=2:sw=2:ts=2:ff=unix:
