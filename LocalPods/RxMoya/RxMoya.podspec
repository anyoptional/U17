#
# Be sure to run `pod lib lint RxMoya.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'RxMoya'
    s.version          = '1.0.0'
    s.summary          = 'Network abstraction layer'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.subspec "Core" do |cs|
        cs.source_files  = "RxMoya/Classes/Core"
        cs.frameworks  = "Foundation"
        cs.dependency 'Moya', '~> 11.0.2'
        cs.dependency 'YYKit', '~> 1.0.9'
        cs.dependency 'RxSwift', '~> 4.1.2'
        cs.dependency 'RxOptional', '~> 3.4.0'
        cs.dependency 'SwiftyJSON', '~> 4.2.0'
    end
    
end
