#
# Be sure to run `pod lib lint FOLDin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'FOLDin'
    s.version          = '1.0.0'
    s.summary          = 'Custom navigaiton bar instead of system provides.'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.frameworks  = "UIKit"
    
    s.ios.deployment_target = '9.0'
    
    s.resource_bundles = {
        'FOLDin' => ['FOLDin/Assets/*.png']
    }
    
    s.public_header_files = "FOLDin/Classes/Core/*.h"
    
    s.subspec "Core" do |cs|
        cs.source_files  = "FOLDin/Classes/Core"
    end
end
