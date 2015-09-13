#
#  Be sure to run `pod spec lint Swicon.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Swicon"
  s.version      = "0.90"
  s.summary      = "Use 1600+ icons from FontAwesome and Google Material Icons in your iOS project in an easy and space-efficient way!"
  s.description  = <<-DESC
                   Use 1600+ icons from FontAwesome and Google Material Icons in your iOS project in an easy and space-efficient way!
                   Use those icons in UILabel, UIButton or parse them into an UIImage with ONE line of code.
                   DESC
  s.homepage     = "https://github.com/UglyTroLL/Swicon"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author       = { "Zhibo Wei" => "zweicmu@gmail.com" }
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/UglyTroLL/Swicon.git", :tag => "0.90" }
  s.source_files  = "Swicon/Swicon/*.{swift}"
  s.resource_bundle = { 'Swicon' => 'Swicon/Swicon/*.ttf' }
  s.frameworks = 'UIKit', 'CoreText'

end
