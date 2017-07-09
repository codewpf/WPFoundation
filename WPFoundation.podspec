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
s.social_media_url = 'https://twitter.com/alexsayhi0394'

s.ios.deployment_target = '8.0'

s.source_files = 'Sources/**/*.swift'

# s.resource_bundles = {
#   'WPFoundation' => ['WPFoundation/Assets/*.png']
# }



# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
