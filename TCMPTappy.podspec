#
# Be sure to run `pod lib lint TCMPTappy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TCMPTappy'
  s.version          = '1.1.0'
  s.summary          = 'SDK for using TapTrack Tappy NFC Readers such as the TappyBLE.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Integrate the TapTrack external NFC readers into your own native iOS application.  Currently supports TappyBLE readers for iPhones and iPads.
                       DESC

  s.homepage         = 'https://github.com/TapTrack/TCMPTappy-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'David Shalaby' => 'info@taptrack.com', 'Alice Cai' => 'info@taptrack.com' }
  s.source           = { :git => 'https://github.com/TapTrack/TCMPTappy-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = "4.2"

  s.source_files = [
    "TCMP/**/*.{swift,m,h}",
    "TappyBLE/**/*.{swift,m,h}",
    "TappyReader/**/*.{swift,m,h}",
  ]
  
  # s.resource_bundles = {
  #   'TCMPTappy' => ['TCMPTappy/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
