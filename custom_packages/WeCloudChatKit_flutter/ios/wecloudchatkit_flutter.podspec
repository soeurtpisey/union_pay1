#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wecloudchatkit_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wecloudchatkit_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source           = { :git => "https://github.com/signalapp/SignalCoreKit.git", :commit => "5a9c6be791459177328b5da14bf06459e7b79dbb" }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'SwiftProtobuf'
  s.dependency 'Curve25519Kit'
  s.dependency 'CocoaLumberjack'
  s.dependency 'SignalCoreKit'
  s.dependency 'AxolotlKit'
  s.dependency 'HKDFKit'
  s.vendored_frameworks = 'WeCloudIMSDK.framework'

  s.platform = :ios, '11.0'
  s.swift_version = '5.0'
  
  s.static_framework = true



  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
