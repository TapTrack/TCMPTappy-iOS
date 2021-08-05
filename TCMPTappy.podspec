Pod::Spec.new do |s|
  s.name             = 'TCMPTappy'
  s.version          = '1.3.1'
  s.summary          = 'SDK for using TapTrack Tappy NFC Readers such as the TappyBLE.'

  s.description      = <<-DESC
  Integrate the TapTrack external NFC readers into your own native iOS application.  Currently supports TappyBLE readers for iPhones and iPads.
                       DESC

  s.homepage         = 'https://github.com/TapTrack/TCMPTappy-iOS'
  s.license          = { :type => 'Apache', :file => 'LICENSE' }
  s.author           = { 'David Shalaby' => 'info@taptrack.com', 'Alice Cai' => 'info@taptrack.com' }
  s.source           = { :git => 'https://github.com/TapTrack/TCMPTappy-iOS.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TapTrack'

  s.ios.deployment_target = '12.0'
  #The project is updated to Swift 5 but using 4.2 in the podspec avoids warnings
  s.swift_version = "4.2"

  s.source_files = [
    "TCMP/**/*.{swift,m,h}",
    "TappyBLE/**/*.{swift,m,h}",
    "TappyReader/**/*.{swift,m,h}",
  ]
  
  s.dependency 'SwiftTLV'
  
  # s.resource_bundles = {
  #   'TCMPTappy' => ['TCMPTappy/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
 
end
