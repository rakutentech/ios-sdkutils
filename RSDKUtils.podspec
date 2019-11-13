Pod::Spec.new do |s|
  s.name         = "RSDKUtils"
  s.version      = "1.0.0"
  s.authors      = "Rakuten Ecosystem Mobile"
  s.summary      = "Rakuten's SDK Team internal utilities module."
  s.homepage     = "https://documents.developers.rakuten.com/ios-sdk/"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source       = { :git => "https://github.com/rakutentech/ios-sdkutils", :tag => s.version.to_s }
  s.platform     = :ios, '10.0'
  s.swift_version = '5.0'
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
    'Foundation',
  ]
  s.source_files = "RSDKUtils/**/*.{swift,m,h}"
  s.public_header_files = "RSDKUtils/*.h,RSDKUtils/StandardHeaders/*.h"
  s.module_map = 'RSDKUtils/RSDKUtils.modulemap'
end
# vim:syntax=ruby:et:sts=2:sw=2:ts=2:ff=unix:
