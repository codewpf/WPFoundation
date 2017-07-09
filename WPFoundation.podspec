Pod::Spec.new do |s|
s.name             = 'WPFoundation'
s.version          = '0.1.0'
s.summary          = 'WPFoundation is a private foundation framework for iOS develop'
s.homepage         = 'https://github.com/codewpf/WPFoundation'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Alex' => 'ioswpf@gmail.com' }
s.source           = {
    :git => 'https://github.com/codewpf/WPFoundation.git',
    :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/Alex___0394'

s.ios.deployment_target = '8.0'

s.source_files = 'Sources/**/*.swift'

#s.preserve_paths = 'Sources/WPFCommonCrypto/module.modulemap'
#s.xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/WPFoundation/Sources/WPFCommonCrypto' }

# s.resource_bundles = {
#   'WPFoundation' => ['WPFoundation/Assets/*.png']
# }

s.preserve_paths = 'CocoaPods/**/*'
s.pod_target_xcconfig = {
'SWIFT_INCLUDE_PATHS[sdk=macosx*]'           => '$(PODS_ROOT)/WPFoundation/CocoaPods/macosx',
'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]'         => '$(PODS_ROOT)/WPFoundation/CocoaPods/iphoneos',
'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_ROOT)/WPFoundation/CocoaPods/iphonesimulator',
'SWIFT_INCLUDE_PATHS[sdk=watchos*]'          => '$(PODS_ROOT)/WPFoundation/CocoaPods/watchos',
'SWIFT_INCLUDE_PATHS[sdk=watchsimulator*]'   => '$(PODS_ROOT)/WPFoundation/CocoaPods/watchsimulator'
}



# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
