#
# Be sure to run `pod lib lint Mediator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'Mediator'
    s.version          = '1.0.0'
    s.summary          = 'Mediator pattern.'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.frameworks  = "UIKit"
    
    s.ios.deployment_target = '8.0'
    
    s.public_header_files = "Mediator/Classes/Supports/*.h"
    
    s.subspec "Core" do |cs|
        cs.source_files  = "Mediator/Classes/Core"
    end
    
    s.subspec "Supports" do |ss|
        ss.source_files  = "Mediator/Classes/Supports"
    end
    
    s.subspec "Category" do |sc|
        sc.source_files  = "Mediator/Classes/Category"
    end
    
end
