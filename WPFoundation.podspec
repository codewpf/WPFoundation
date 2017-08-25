Pod::Spec.new do |s|
s.name             = 'WPFoundation'
s.version          = '0.3.0'
s.summary          = 'WPFoundation is a private foundation framework for Swift develop'
s.license          = { :type => 'MIT', :file => 'LICENSE' }

s.homepage         = 'https://github.com/codewpf/WPFoundation'

s.author           = { 'Alex' => 'ioswpf@gmail.com' }
#s.social_media_url   = "https://twitter.com/Alex___0394"

s.platform     = :ios, "9.0"

s.source           = { :git => 'https://github.com/codewpf/WPFoundation.git', :tag => s.version.to_s }

s.source_files = 'Sources/WPFoundation.swift'


end
